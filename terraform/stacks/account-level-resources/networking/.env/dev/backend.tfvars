bucket         = "terraform-remote-state-rag-demo-dev"
key            = "networking/state.tfstate"
region         = "us-east-1"
encrypt        = "true"
dynamodb_table = "terraform_state_lock"