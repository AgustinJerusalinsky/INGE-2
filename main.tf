terraform {

  backend "remote" {
    # The name of your Terraform Cloud organization.
    organization = "ITBA-INGE2"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "INGE-2"
    }
  }


  required_providers {
    heroku = {
      source  = "heroku/heroku"
      version = "~>4.0"
    }
  }
}

resource "heroku_app" "default" {
  name   = "itba-webapp"
  region = "us"
}

resource "heroku_addon" "postgres" {
  app  = heroku_app.default.id
  name = "itba-webapp-db"
  plan = "heroku-postgresql:hobby-dev"
}

resource "heroku_build" "default" {
  app = heroku_app.default.id

  source {
    path = "./webapp/"
  }
}

resource "heroku_formation" "default" {
  app        = heroku_app.default.name
  type       = "web"
  quantity   = 1
  size       = "Free"
  depends_on = [heroku_build.default]
}
