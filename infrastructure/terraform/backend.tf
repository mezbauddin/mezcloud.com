terraform {
  cloud {
    organization = "MezCloud"

    workspaces {
      name = "MezCloud-workspace"
    }
  }
}
