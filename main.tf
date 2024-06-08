#main.tf

provider "aws"{
	region="us-west-2"
}
resource "aws_ecs_cluster"
"app_cluster"{
	name="my-ecs-cluster"
}
resource "aws_ecs_task_defination"
"app_task"{
	family="my-app-task"
	network_mode="awsvpc"
	cpu=256
	memory=512
	requires_compatibilities=["FARGATE"]

	container_definations=jsonencode([
	{
		name="my-nodejs-app",
		image=":latest"
		cpu=256,
		memory=512,
		essential=true,
		portMappings=[
		{
			containerPort=3000,
			hostPort=3000,
			protocol="tcp",
		},
	],
	},
	])
}
resource "aws_ecs_service"
"app_service"{
	name="my-app-service"
	cluster=aws_ecs_cluster.app_cluster.id
	task_defination=aws_ecs_task_defination.app_task.arn
	desired_count=
	launch_type="FARGATE"

	network_configuration{
		subnets=[]
		security_groups=[]
		assign_public_ip=true
	}
}
