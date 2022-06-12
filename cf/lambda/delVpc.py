import boto3
import json

def lambda_handler(event, context):
  # TODO implement
  #for looping across the regions
  regionList=[]
  region=boto3.client('ec2')
  regions=region.describe_regions()
  #print('the total region in aws are : ',len(regions['Regions']))
  for r in range(0,len(regions['Regions'])):
      regionaws=regions['Regions'][r]['RegionName']
      regionList.append(regionaws)
  #print(regionList)
  regionsl=['us-east-1']
  #sending regions as a parameter to the remove_default_vps function
  res=remove_default_vpcs(regionList)


  return {
      'status':res
  }

def get_default_vpcs(client):
  vpc_list = []
  vpcs = client.describe_vpcs(
    Filters=[
      {
          'Name' : 'isDefault',
          'Values' : [
            'true',
          ],
      },
    ]
  )
  vpcs_str = json.dumps(vpcs)
  resp = json.loads(vpcs_str)
  data = json.dumps(resp['Vpcs'])
  vpcs = json.loads(data)

  for vpc in vpcs:
    vpc_list.append(vpc['VpcId'])  

  return vpc_list

def del_igw(ec2, vpcid):
  """ Detach and delete the internet-gateway """
  vpc_resource = ec2.Vpc(vpcid)
  igws = vpc_resource.internet_gateways.all()
  if igws:
    for igw in igws:
      try:
        print("Detaching and Removing igw-id: ", igw.id) if (VERBOSE == 1) else ""
        igw.detach_from_vpc(
          VpcId=vpcid
        )
        igw.delete(

        )
      except boto3.exceptions.Boto3Error as e:
        print(e)


def remove_default_vpcs(res):
  for region in res:
    try:
      client = boto3.client('ec2', region_name = region)
      ec2 = boto3.resource('ec2', region_name = region)
      vpcs = get_default_vpcs(client)
    except boto3.exceptions.Boto3Error as e:
      print(e)
      exit(1)
    else:
  
      for vpc in vpcs:
        print("\n" + "\n" + "REGION:" + region + "\n" + "VPC Id:" + vpc)
        #del_igw(ec2, vpc)

#print(completed)