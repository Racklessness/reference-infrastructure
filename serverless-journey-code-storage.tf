module "serverless-journey-storage-bucket" {
  source = "./lambda-storage-bucket"
  bucket_name = "serverless-journey-deployment"
}