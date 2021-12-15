# next-docs-starter
The purpose of this project is to form a base for a NextJS Docs markdown (mdx) documentation website to be deployed on AWS via terraform.

Cloud Requirements:
- terraform cli
- AWS credentials for terraform setup as the default profile
- Route53 domain name that you will be referencing

Inputs
- var.website_domain_main (this is your root domain such as "example.com")
- var.website_domain_redirect (this is your redirect url such as "www.example.com")

## Clone the repo
```
git clone https://github.com/brendenvogt/next-docs-starter
cd next-docs-starter
```

## Run the dev server 
```
yarn
yarn dev
```

## Generate/export static website 
```
yarn build
```

## Deploy
```
yarn plan
yarn apply
```

## Destroy
```
yarn destroy
```