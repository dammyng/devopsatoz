provider "google" {
  project = "PROJECT_ID"
  region  = "us-central1"
}

resource "google_cloudfunctions_function" "function_app" {
  name        = "function_app"
  runtime     = "nodejs12"
  source_archive_bucket = "function-app-bucket"
  source_archive_object = "function_app.zip"
  entry_point = "function_handler"
  environment_variables = {
    "VAR_NAME" = "VAR_VALUE"
  }
}
