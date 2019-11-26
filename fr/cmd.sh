git clone https://github.com/tky/cloudformation.git
cd cloudformation
aws cloudformation create-stack --stack-name ci-visualization --template-body file://ci_visualization.json --parmeters \
	ParameterKey=VpcId, ParameterValue=[tkyVPC ID] \
	ParameterKey=SubnetId,ParmeterValue=[tky SubnetID] \
	ParmeterKey=KeyName,ParameterValue=[tky keypairname]

ssh -i tkysshkey centos@CIserverIPaddr
aws cloudformation delete-stack --stack-name ci-visualization
