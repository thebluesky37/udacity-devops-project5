#!/bin/bash
create ()
{
    echo Creating ${stack_name} stack
    aws cloudformation create-stack \
        --stack-name ${stack_name} \
        --template-body file://${scripts_path}${template_body} \
        ${parameters_opt} \
        --tags Key=Name,Value=${environment_name} \
        --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" \
        --region=us-east-1

    aws cloudformation wait \
        stack-create-complete \
        --stack-name $stack_name
}

update ()
{
    echo Updating ${stack_name} stack
    aws cloudformation update-stack \
        --stack-name ${stack_name} \
        --template-body file://${scripts_path}${template_body} \
        ${parameters_opt} \
        --tags Key=Name,Value=${environment_name} \
        --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" \
        --region=us-east-1
    
    aws cloudformation wait \
        stack-update-complete \
        --stack-name $stack_name
}

delete ()
{
    echo Deleting ${stack_name} stack
    aws cloudformation delete-stack \
        --stack-name ${stack_name}
        
    aws cloudformation wait \
        stack-delete-complete \
        --stack-name $stack_name
}

main()
{
    if [ -z "$stack" ]; then
        echo "Please define the needed stack"
        echo "e.g. ./run.sh <stack> <function>"
        exit 1
    fi

    if [[ $(type -t $function) == function ]]; then
        $function
    else
        echo "$function isn't a supported function!"
        exit 1
    fi
}

scripts_path=cloudformation/
environment_name=udacitydevops5
stack=$1
stack_name=$environment_name-$stack
template_body=$stack.yaml
parameters=$stack-params.json
function=$2

if [ -e "$scripts_path$parameters" ]; then
    parameters_opt="--parameters file://${scripts_path}${parameters}"
else
    parameters_opt=
fi

main