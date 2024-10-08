name: Build and validate

on:
  push:
    branches:
      - 'master'
    paths:
      - "models/**/**/*.sql"
      - "models/**/**/**/*.sql"
      - "models/**/*.sql"
      - "models/*.sql"
  workflow_dispatch:
concurrency: ${{ github.ref }}

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: 3.9

      - id: authenticate
        uses: google-github-actions/auth@v2
        with:
          credentials_json: ${{ secrets.GCP_SA_KEY}}
          export_environment_variables: true
          create_credentials_file: true

      - run: |
          pip install -r requirements.txt
          dbt deps

      - name: Push flow - Run
        id: push_flow_run
        if: github.event_name == 'push'
        run: |
          dbt run --profiles-dir $PWD --project-dir $PWD --select state:modified --defer --state prod
          
      - name: Push flow - Test
        id: push_flow_test
        if: github.event_name == 'push'
        run: |
          dbt test --profiles-dir $PWD --project-dir $PWD --select state:modified --defer --state prod

      - name: Generate docs
        id: compile
        if: github.event_name == 'push'
        run: |
          dbt compile && dbt docs generate --no-compile
          find ./target -name \*.json -exec cp -v '{}' './prod' ';'
        continue-on-error: true
      - name: Add Manifest to Repo
        if: github.event_name == 'push'
        uses: EndBug/add-and-commit@v9
        with:
          add: './prod'
          committer_name: Github Actions
          committer_email: actions@github.com
          message: 'Adding manifest from merge run'
      - name: Deploy to Netlify
        if: github.event_name == 'push'
        uses: nwtgck/actions-netlify@v2.0
        with:
          publish-dir: './target'
          deploy-message: "Deploy from GitHub Actions"
          enable-pull-request-comment: false
          enable-commit-comment: true
          overwrites-pull-request-comment: true
        env:
          NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
          NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
        timeout-minutes: 1
        continue-on-error: true