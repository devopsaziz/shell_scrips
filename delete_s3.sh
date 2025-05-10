for bucket in $(aws s3api list-buckets --query "Buckets[].Name" --output text); do
  echo "Processing bucket: $bucket"
  
  # Delete all versions
  versions=$(aws s3api list-object-versions --bucket $bucket --query 'Versions[].{Key:Key,VersionId:VersionId}' --output text)
  for ver in $versions; do
    key=$(echo $ver | awk '{print $1}')
    vid=$(echo $ver | awk '{print $2}')
    aws s3api delete-object --bucket $bucket --key "$key" --version-id "$vid"
  done
  
  # Delete all delete markers
  markers=$(aws s3api list-object-versions --bucket $bucket --query 'DeleteMarkers[].{Key:Key,VersionId:VersionId}' --output text)
  for mark in $markers; do
    key=$(echo $mark | awk '{print $1}')
    vid=$(echo $mark | awk '{print $2}')
    aws s3api delete-object --bucket $bucket --key "$key" --version-id "$vid"
  done

  # Delete the bucket
  aws s3api delete-bucket --bucket $bucket --region eu-north-1
done

