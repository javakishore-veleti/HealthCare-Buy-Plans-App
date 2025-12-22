# 1. Navigate to your git repo root folder
# cd git_repo_root_folder
  cd .

# 2. Create the front_end_code folder
mkdir -p front_end_code

# 2. Navigate into it
cd front_end_code

# 4. Create Angular app (healthcare_plans_ui)
ng new healthcare_plans_ui --routing --style=scss --strict

# 5. Navigate into the Angular app
cd healthcare_plans_ui

# 6. Add Bootstrap 5
npm install bootstrap

# 7. Add Angular JWT library (for handling JWT tokens)
npm install @auth0/angular-jwt
```

After running `ng new`, Angular CLI will ask:
- **Would you like to enable autocompletion?** → Yes or No (your preference should be Yes)
- **Would you like to share pseudonymous usage data?** → Yes or No (your preference should be No)
- ** ✔ Do you want to create a 'zoneless' application without zone.js (Developer Preview)? Yes
- * *✔ Do you want to enable Server-Side Rendering (SSR) and Static Site Generation (SSG/Prerendering)? Yes

###
###Once created, your structure will be:
### ```
### git_repo_root_folder/
### └── front_end_code/
###    └── healthcare_plans_ui/
###        ├── src/
###        │   └── app/
###        ├── angular.json
###        ├── package.json
###        └── ...
###```        