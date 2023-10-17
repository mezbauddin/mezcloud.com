# Project Journal

Installed dJango, waigtail, but currently only using it to load static pages, not sure how to make it dynamic. Waigtail is a installed as a plugin to dJango but its not configured yet also need to migrate the database to postgresql. Project structure is a bit confusing, need organize it. At some i will docarize the project and deploy it to a kubernetes cluster using github actions and workflow ci/cd pipeline, at some point ill automate the deployment of the cluster via terraform. Current deplopment environment is a virtual machine running Parrot OS, i will eventually move it to a docker container, aslo setup github codespaces for development. Also need to setup monitoring using promithius and grafana. 



# Day 1: 2023-05-28  9:00 AM

- Changed the home app name to home.old to see how it affets the project - it broke the project with the following error:

```ModuleNotFoundError: No module named 'home'```

- Commented # the base.py file in the settings folder, it fixed the error. I will delete the home app all together if it does not break the project, but i suspect it will brake the waigtail admin part of the project. Waigtail is working fine but opton to add pages is missing, i think its because the home app is missing. But i will leave it for now. renamed the web app to web_old so i can chanhe the home app to web, once done ill rename the home to web and delete the web_old app.

- Trying to figure out how to make the project dynamic, Ill move the static page from web app to waigtail, it it work ill delete the web app and try to make the project dynamic.

- It did not work, i have chanceg everthing back to the way it was, calling it a day.

# Day 2: 2023-05-29  9:00 AM

- Fixed git isue - test sucessful - issue was git extension for vscode, has master branch as default, changed it to main as GitHub has default branch name from master to main. which owas creating conflict with the local branch.

- Modified the Dockerfile wich comes with th waigtail project, it works, but i need to run 
'''
./manage.py createsuperuser
'''

 to create a superuser, i will have to figure out how to do it automatically, i will have to do some research on it tomorrow, i will  Dockerfile and Docker-compose file for the project. Becouse the default Dockerfile is not suitable for production, it uses the development server, which only works on port 8000, i need to run it on port 80. Changed the docker file its runs directly on mezbauddin.com. 

- Another issue is that the data is not persistent, i will have to figure out how to make it persistent, i will have to do some research on it tomorrow.

- If it woks ill modefy the Dockerfile and Docker-compose file to use it for production with gunicorn, nginx and postgresql. I will also have to figure out how to separate the services using Docker-compose, i will have to do some research on it tomorrow.

# Day 3: 2023-05-30  1:01 AM

- Changed home app template now showing conete but cannot edit or show angthing from the admin panel, added '''{% load wagtailcore_tags %} and {{ page.body|richtext }}''' to the home.htm template now i can add content from admin still need to figure out how to edit the page from the admin panel. I will have to do some research on it later after i come back from gym.

# Day 4: 2023-06-10  9:00 AM

- changed ngnix to traefik, comented some code in the docker-compose file, and renamed ngnix to nginx_old, cameaccross letsncrypt cret limit isee. Ill wait till tomorrow to see if it fixes itself, if not i may have to revert back to ngnix. Added treafik again will keep it for now pretty sure it will work tomorrow.

- Added a promithius and grafna in saparet containers to monitor the project, but having some connection issue maybey i need to create them containers via docker-compose. Deployed via docker-compose, connected promithius to grafina, created a dashboard 'treafik' to monitor traefik from official template, but its not working, i belive its because of the letsecrypt issue, i will have to wait till tomorrow to see if it fixes itself after the limit is lifted. Tested by desabling ssl to see if it works, it did not work neet to check the traefik logs to see whats going on.

- Also added Ansible and terraform to the server to automate the deployment of the project, need to figure out how to do that.
- Yet to deside where to host it AWS, GCP, Azure, or DigitalOcean or local vm or bare metal server. Need to ask an expert or find a mentor to help me with this project.

# Day 5: 2023-06-11  9:00 AM

- Started the day with tiding up the docker env and the project, deleted all the unused files and folders.

- SSL limit is lifted, traefik is working, but promithius and grafana only works in local host but not in mezbaudin.com:9090 and mezbaudin.com:3000, added subdomains for promithius and grafana, updated the yml. But letsencript limit is reached again, i will have to wait till 13th June. Need to find a way to fix the letsencript limit issue, i will have to do some research on it later. Done for the day will continue tomorrow.

- Ill take a break from the project will be back to it on 13th June. meanwile ill study mojo lang and HTB.

# Day 6: 2023-06-12  9:00 AM

- Invested the evening on the isses which i left behind, But managed to fix the letsencript limit issue, i have modified the docker-compose file to use letsencrypt staging server, so it does not count towards the limit, i have also made it swichable to production server, using comments in the docker-compose file. now i have to make it more efficient and auto mate this with more simplar docker-compose file. cant decide if i should two docker-compose files or one. Probably two will be better, one for staging and one for production, if i do this then i ahve to make cahnges to the git action workflow file for the CI/CD pipeline to work.

- Also ill change the workflow file to use the docker-compose file to deploy the project to the server, instead of using the staging. Git push should only trigger the CI/CD pipeline when marged to the main branch, but before that i have to understand the git branches better. 

# Day 7: 2023-06-13  9:00 AM

- Aded a condition in the workflow file now it will deploy the docker-compose.prod.yml file if i push to the min brunch, push to the dev branch will deploy the docker.stging.yml file. prod uses actual ssl and the staging uses letsencrypt staging server. Now in theary i should be able to use the staging ssl to test and avoid the letsencrypt limit issue, but i have to wait till tomorrto to test it. 

- Once it works i need to findout how to automate dev to prod deployment, using git branch and git marge. ill speak to kawsar about it on friday the 18th June.

- I also need to remove the letsencrypt docker volume and traefik docke container and reacreate them automatically, it will makesre that the correct ssl is used for the correct docker container. I am ot sure if every push cretes a new cert or not, also the cert stored in letsencrypt volume is not overlaping bitween staging and production.

- Every thing done correctly the the ssl issue will be sorted.

- I will create a new branch called staging which will be hosted on a raspberry pi 4 to test the project before deploying it to the main server. I will also use it to test the CI/CD pipeline. also might move the production on azure or aws or gcp or digital ocean and the parrot server then will be used for learning and development.

# Day 8: 2023-06-14  9:00 AM

- Subdomains issue was solved by Enabling traefik for the subdomain ' - "traefik.enable=true" ' in the docker-compose file. I cosetd me about 2 hours to figure it out.

- Also learn how to add basic auth to the traefik dashboard, that was nice and easy.

- The SSL isse is resolved too, Finally i can proceed to the next step - Kubernetes. 

# Day 9: 2023-06-17 12.35 AM

- No, just discovered that I need to change the action workflow, at the moment it's triggered by push to dev > Staging.yml and master > Prod.yml because of this mezbauddin.com getting the let'sencrypt staging cert. 

- Possible opton to fix the issue:

1. Stop the action not to trigger on push to dev but then I have manually merge dev > main branch or create some sort of automated test to marge dev > master.

2. Configure the workflow to deploy prod.yml > main branch > mezbauddin.com and staging.yml > staging branch > staging.mezbauddin.com - need to auto merge dev to staging for this to work.

- Recreated the git repo added staging branch. workflow looks like dev > staging > main dev dont trigger any action, staging trigger the staging.yml and main trigger the prod.yml which solves the issue if i push to the main but i need to automate this flow from dev to staging to main using git merge and automated test chatting with gpt to findout the best option.

- Started configuring the Raspberry Pi 4 to host the staging branch, Installed docker and docker-compose need make it accessible from the internet using cloudflare tunnel. Raspberry pi keeps droping the ssh connection randomly, need to investigate this issue.


# Day 10: 2023-06-18 20.14 PM

- Writing a functional test for the app so i can proceed with automte dev > staging > prod. 

- added test in home and staging, changed the docker compose file, workfolw saved as backup.main create d new one to test push deploy dev> staging > prof. if dosent owrk need to reverce what i have done today. 

# Day 11: 2023-06-19 12.40 AM

- Test fails but no problem as this can be easily fixed by updating static file paths and adding missing static file - css.

- updated the CI/CD workflow - Push to dev -> Build Docker Image -> Push Image to Docker Hub -> Start test container-> Run Tests -> Deploy to Staging -> Run Staging Tests -> Manual Approval -> Check Approval Status -> If Not Approved in 24 hours -> Deploy to Main.

- I'll know if it works once I have fixed the static file issues, also need to remove unused files and folders 📂

# Day 12: 2023-06-20 12.40 AM

- Spent all day fixing the database connection isseu, endup re creating everthing from scratch. Atlist now i have a better understanding of the project, need to look at the test tomorrow.

- Updated the projects enverionmet to poetry, added poetry.lock and pyproject.toml, removed the requirments.txt file, Updated the the docker & docker-compose file to use poetry to install the dependencies.

- Need to update the project structur and add .env file to the project to manage it efficiently, Installed - poetry add python-decouple it will help to manage the .env file will configure it later.


# ~
