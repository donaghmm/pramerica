Forenote:
=========
- Ansible version used: 2.4.1.0
- Deployment is done in Ireland region that has 3 AZ.

Checkout the script:
===================
- clone the repo: https://github.com/rajboruah/pramerica.git
- move it to HOME dir

What needs to be done in Ansible control machine:
=================================================
- install aws-cli in the ansible control machine if not available: 
     curl -O https://bootstrap.pypa.io/get-pip.py
     apt -y update && apt install -y python-minimal (needed only if control machine does not have Python2, Ansible does not support Python 3)
     sudo python2.7 get-pip.py
     sudo pip install awscli

- Disable host_key_checking (i.e. host_key_checking = False) in /etc/ansible/ansible.cfg
- Set 'remote_user = ubuntu' in /etc/ansible/ansible.cfg (Disable/Remove 'remote_user = root')
- AWS console login link has been sent in an email
- AWS account details for console login has been sent in a email.
- pramerica.pem is sent in an email.
 
- configure aws credential with the Access Key ID & Secret Access Key provided in the email. 
  aws configure
    :<AWS Access Key ID>  
    :<AWS Secret Access Key>
    :eu-west-1
    :json

- Reset permission in pramerica.pem file: 'chmod 400 ~/pramerica.pem'
- run ssh-agent before starting the script:
  ssh-agent bash
  ssh-add ~/pramerica.pem
  verify that key is added successfully: 'ssh-add -L'

- run the ansible script:
  cd ~/<home>/pramerica/
  ansible-playbook apache_tomcat_playbook.yml

Testing the setup:
=================

- "http://<ELB-DNS name>" will land you in Apache web server page
- "http://<ELB-DNS name>/pramerica/helloworld" will land you in Tomcat server page

Please note that apart from the default index file, other scripts may not work as they are not configured.

Testing:
========
- terminate an instance, another instance will get launched and will install all packages & configure AJP
- to rerun the deployment script, please remove the 
   -autoscaling group ("apache-tomcat-rajen"),
   -launch configuration ("apache-tomcat-rajen") 
   -elb ("apache-tomcat-rajen")
