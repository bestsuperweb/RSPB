Aws.config.update({
  region: 'us-east-1',
  credentials: Aws::Credentials.new( 'AKIAJ6DTJ2OCZMEWVMEQ', 'GjBFmi6ljQQlKmLM/+n1rYhBl3DD+jSb4kVZIcDA' ),
})

S3_BUCKET = Aws::S3::Resource.new.bucket('clipping-path-india')