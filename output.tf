output "serverless-journey-invoke-url" {
  value = module.serverless-journey-apigateway-proxy.invoke_url
}

output "user-pool-id" {
  value = module.serverless-journey-auth.user-pool-id
}

output "user-pool-client-id" {
  value = module.serverless-journey-auth.user-pool-web-client-id
}

output "user-pool-url" {
  value = module.serverless-journey-auth.user-pool-web-client-url
}
