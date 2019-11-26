git clone https://github.com/tky/cloudformation.git
cd cloudformation
aws cloudformation create-stack --stack-name ci-visualization --template-body file://ci_visualization.json --parmeters \
	ParameterKey=VpcId, ParameterValue=[tkyVPC ID] \
	ParameterKey=SubnetId,ParmeterValue=[tky SubnetID] \
	ParmeterKey=KeyName,ParameterValue=[tky keypairname]

ssh -i tkysshkey centos@CIserverIPaddr
aws cloudformation delete-stack --stack-name ci-visualization


aws configure
AWS Access Key ID
AWS Secret Acces Key
ap-northeast-1
json

aws cloudformation create-stack --stack-name blue-green-init
--template-body https://raw.githubusercontent.com/tky/cloudformation/master/blue-green-init.json --parmeters ParameterKey=VpcId,ParameterValue=[tkyVPC ID] ParameterKey=SubnetId, ParameterValue=[tkySubnetID] ParmeterKey=KeyName,ParameterValue=[tkyKeyPairName]

git clone https://github.com/tky/cloudformation.git
cd cloudformation

aws cloudformation create-stack --stack-name blue-green-init 
--template-body file://blue-green-init.json --parameters ParameterKey=VpcId,ParameterValues=[tkyVPC ID] ParameterKey=SubnetId.ParameterValue=[tkySubnetID] ParameterKey=KeyName,ParameterValue=[tkyKeyPairName]

aws cloudformation describe-stacks --stack-name blue-green-init --query "Stacks[0].Outputs[].[OutputKey,OutputValue]" --output text

ssh -i SSHkeypariname centos@CiAccessIpAddr

aws cloudformation create-stack --stack-nameblue --template-body file://blue.json --parameters ParameterKey=VpcId,ParameterValue=[tkyVPC ID] ParameterKey=SubnetId,ParameterValue=[SubnetId] ParameterKey=SshSecurityGroupId,ParameterValue=[SshSecurityGroup] ParameterKey=LbSecurityGroupId,ParameterValue=[LbSecurityGroup]

cd ~
gut clone https://github.com/tky/ansible.git
cd ansible

export AWS_ACCESS_KEY_ID=[tkyAccessKeyID]
export AWS_SECRET_ACCESS_KEY=[tkySeacretAccessKey]
ansible-playbook -i inventory/ec2.py blue-webservers.yml --diff --skip-tags serverspec

cd !
cd cloudformation
sh register-instance-with-load-balancer.sh blue ActiveELB

cd ~/cloudformation
aws cloudformation create-stack --stack-name green --template-body file://green.json --parmeters ParameterKey=VpcId,ParameterValue=[tkyVPC ID] ParameterKey=SubnetId,ParameterValues=[tky Subnet ID] ParameterKey=SshSecurity=SubnetId,ParameterValues=[tky Subnet ID] ParameterKey=SshSecurityGroupId, ParameterValue=[SshSecurityGroup] ParameterKey=LbSecurityGroupId,ParameterValue=[LbSecurityGroup]

cd ~/ansible
ansible-playbook -i inventory/ec2.py green-webservers.yml --diff --skip-tags serverspec

cd ~/cloudformation
sh register-instances-with-load-balancer.sh green ActiveELB

sh deregister-instances-from-load-balancer.sh blue ActiveELB

cd ~/cloudformation
sh register-instances-with-load-balancer.sh blue ActiveELB
sh deregister-instances-from-load-balancer.sh green ActiveELB

aws cloudformation delete-stack --stack-name blue
aws cloudformation delete-stack --stack-name green
aws cloudformation delete-stack --stack-name blue-green-init




