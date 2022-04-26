package main

import (
	"flag"
	"fmt"
	"os"
	"github.com/aliyun/alibaba-cloud-sdk-go/services/ecs"
	"errors"
	"time"
	"math/rand"
)

var (
    region, accessKeyId, accessSecret string
 
	confirmCreationCmd = flag.NewFlagSet("confirm-connection", flag.PanicOnError)
)

type ErrorSlice []error

func (e ErrorSlice) Error() string {
	s := ""
	for _, err := range e {
		s += ", " + err.Error()
	}
	return "Errors: " + s
}

func setupGlobalFlags() {
    for _, fs := range []*flag.FlagSet{confirmCreationCmd} {
        fs.StringVar(
            &region,
            "region",
            "",
            "This is the Alicloud region. It must be provided, but it can also be sourced from the ALICLOUD_REGION environment variables",
        )
		fs.StringVar(
            &accessKeyId,
            "access-key",
            "",
            "This is the Alicloud access key. It must be provided, but it can also be sourced from the ALICLOUD_ACCESS_KEY environment variable",
        )
		fs.StringVar(
            &accessSecret,
            "secret-key",
            "",
            "This is the Alicloud secret key. It must be provided, but it can also be sourced from the ALICLOUD_SECRET_KEY environment variable",
        )
    }
}

func checkCredentials() error{
	//TODO check shared credentials file
	if region == "" {
		region = os.Getenv("ALICLOUD_REGION")
	}
	if accessKeyId == "" {
		accessKeyId = os.Getenv("ALICLOUD_ACCESS_KEY")
	}
	if accessSecret == "" {
		accessSecret = os.Getenv("ALICLOUD_SECRET_KEY")
	}

	if region == ""|| accessKeyId == "" || accessSecret == "" {
		return errors.New("missing required credentials")
	}
	return nil
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Missing required command. One of [confirm-creation]")
		os.Exit(1)
	}

	if os.Args[1] == "-v" || os.Args[1] == "-version" || os.Args[1] == "--version" || os.Args[1] == "version" {
		fmt.Println(Version)
		os.Exit(0)
	}
	
	setupGlobalFlags()

	if os.Args[1] == "confirm-creation" {
		confirmCreationCmd.Usage = func() {
			confirmCreationCmd.PrintDefaults()
			os.Exit(0)
		}
		vbrId := confirmCreationCmd.String("vbr-id", "", "Required,")
		localGatewayIp :=  confirmCreationCmd.String("cloud-ip", "", "Required, The IP address of the gateway device on the Alibaba Cloud side.")
		peerGatewayIp := confirmCreationCmd.String("customer-ip", "", "Required, The IP address of the gateway device on the user side.")
		peeringSubnetMask := confirmCreationCmd.String("subnet-mask", "", "Required, The subnet mask for the IP addresses of the gateway devices on the Alibaba Cloud side and on the user side.")

		err := confirmCreationCmd.Parse(os.Args[2:])
		if err != nil {
			fmt.Println("Flags parsing error")
			panic(err)
		}
		
		errs := make([]error, 0)
		err = checkCredentials()
		if err != nil {
			errs = append(errs, err)
		}
		confirmCreationCmd.VisitAll(func (f *flag.Flag) {
			if f.Value.String()=="" {
				errs = append(errs, fmt.Errorf("invalid value for required flag %s", f.Name))
			}
		})
		if len(errs) != 0 {
			err = ErrorSlice(errs)
			confirmCreationCmd.PrintDefaults()
			panic(err)
		}

	    client, err := ecs.NewClientWithAccessKey(region, accessKeyId, accessSecret)
		if err != nil {
			fmt.Print(err.Error())
			os.Exit(1)
		}

		_, err = ModifyVirtualBorderRouterAttribute(*client, *vbrId, *localGatewayIp, *peerGatewayIp, *peeringSubnetMask)
		if err != nil {
			panic(err)
		}

		err = retry(12, 10*time.Second, func() error {

			vbr, err := DescribeVirtualBorderRouter(*client, *vbrId)
			if err != nil {
				return errors.New("fail")
			}
			
			if vbr.Status == "active" {
				fmt.Println("VBR creation confirmed")
				return nil
			}

			if vbr.Status != "unconfirmed" {
				return stop{fmt.Errorf("unexpected VBR status error: %v", vbr.Status)}
			}
			return errors.New("VBR status is still unconfirmed")
		})

		if err != nil {
			panic(err)
		}

		os.Exit(0)
	}

	fmt.Println("Unknown command")
	os.Exit(1)
}

func init() {
	rand.Seed(time.Now().UnixNano())
}

func retry(attempts int, sleep time.Duration, f func() error) error {
	if err := f(); err != nil {
		if s, ok := err.(stop); ok {
			return s.error
		}

		if attempts--; attempts > 0 {
			jitter := time.Duration(rand.Int63n(int64(sleep)))
			sleep = sleep + jitter/2

			time.Sleep(sleep)
			return retry(attempts, 2*sleep, f)
		}
		return err
	}

	return nil
}

type stop struct {
	error
}

