#!/bin/bash

ceck_awscli() {
	if ! command -v aws &> /dev/null; then
		echo "aws cli is not installed"
		
	fi
}

install_awscli() {
	echo "install aws cli"
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	sudo apt-get install -y unzip
        unzip awscliv2.zip
        sudo ./aws/install
        awscli -v


}

wait_for_instance() {
	local instance_id="$1"
	echo "waiting for instance $instance_id to be in runnig state"

	while true; do
		state=$(aws ec2 describe-instances --instance-ids "$instance_id" --query 'Reservations[0].Instances[0].State.Name' --output text)
		if [[ "$state" == "running" ]]; then
			echo "instance $instance_id is now running."
			break
		fi
		sleep 10
	    done
}


	  

create_ec2_instance() {
    local ami_id="$1"
    local instance_type="$2"
    local key_name="$3"
    local subnet_id="$4"
    local security_group_ids="$5"
    local instance_name="$6"

    # Run AWS CLI command to create EC2 instance
    instance_id=$(aws ec2 run-instances \
        --image-id "$ami_id" \
        --instance-type "$instance_type" \
        --key-name "$key_name" \
        --subnet-id "$subnet_id" \
        --security-group-ids "$security_group_ids" \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance_name}]" \
        --query 'Instances[0].InstanceId' \
        --output text
    )


    if [[ -z "$instance_id" ]]; then
	    echo "failed to create ec2" >&2
	    exit 1

    fi


    echo "instance $instance_id created successfully"

    # wait for the instance to be in running state
    wait_for_instance "$instance_id"

}


main() {
    check_awscli || install_awscli

    echo "Creating EC2 instance..."

    # Specify the parameters for creating the EC2 instance
    AMI_ID="ami-02b8269d5e85954ef"
    INSTANCE_TYPE="t3.micro"
    KEY_NAME="aws"
    SUBNET_ID=""
    SECURITY_GROUP_IDS=""launch-wizard-11  # Add your security group IDs separated by space
    INSTANCE_NAME="Shell-Script-EC2-Demo"

    # Call the function to create the EC2 instance
    create_ec2_instance "$AMI_ID" "$INSTANCE_TYPE" "$KEY_NAME" "$SUBNET_ID" "$SECURITY_GROUP_IDS" "$INSTANCE_NAME"

    echo "EC2 instance creation completed."
}

main "$@"
