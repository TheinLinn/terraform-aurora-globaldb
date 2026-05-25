provider "aws" {
  region = var.primary_region

  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
    }
  }
}

provider "aws" {
  alias  = "dr"
  region = var.dr_region

  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
    }
  }
}