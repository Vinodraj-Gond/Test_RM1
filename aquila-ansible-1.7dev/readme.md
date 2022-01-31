# Aquila Deployment Scripts

# Prerequisite
1. Create a control node [OPTIONAL]
   - Use a dedicated machine. You can create either a cloud9 instance (recommended),standalone EC2 instance or even your own machine (not recommended).
   - You can skip python installation if you are using Ubuntu 18.04 AMI, it comes with python3.
2. Prepare AWS IAM Role/AWS Access Key for your machine - please reference `terraform/control-node/iam.json` for the necessary IAM permissions. 
3. Copy `aquila-ansible` script to the control node
4. Install Python3 - [Guide](https://opensource.com/article/19/5/python-3-default-mac), [Alternative Guide](https://phoenixnap.com/kb/how-to-install-python-3-ubuntu)
5. Install Terraform - [Guide](https://learn.hashicorp.com/tutorials/terraform/install-cli)
6. Install Ansible - **DO NOT** install ansible via `apt-get` as it installs an outdated version - [Guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
7. Update `config/ansible.yml`

# Main Commands
```
# Run playbook 1 - create blockchain node AWS resources
ansible-playbook 1-resources/playbook.yml -i terraform/blockchain-node/hosts

# Run playbook 2 - Skips prompt and adds host to ~/.ssh/known_host automatically. Configure and installs dependencies then runs the node.
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook 2-node/playbook.yml -i terraform/blockchain-node/hosts
```

# Onboarding
Provide to Aqilliz, *PeerId* and *Public Key (hex)* you can find in the autogenerated files:
- `"{{ playbook_dir }}/../output-peerid.txt"`
- `"{{ playbook_dir }}/../output-aura.txt"`
- `"{{ playbook_dir }}/../output-gran.txt"`

The information to share should look like something similar to this:

```
PeerId
12D3KooWEJW4z7qbQs56YfAUFfYXxoe1chKquE3aKa56GSoyFvoT

Aura
Public key (hex):  0x7826b3ebe293a7ef89c143dd866dd3f10bbc1a8d8081e1e17a57aa99ef245b38
SS58 Address:      5EnF6nDGiG7ceRQP5pHtS2UCbb56SDG1UWDFhvuxkDdNpzZk

Grandpa
Public key (hex):  0xabb1756a8c8b43bc928e13327da828e573055b81b9a9faaba6c1bf08e783215d
```

### _IMPORTANT NOTE_
- DO NOT share with anybody Aura and Grandpa Secret Seed and Secret Phrase
- Keep a copy of the files in a safe place.

Once the file has been shared, please contact Aqilliz to finalize the onboarding process.

# Others
```
# SSH into node
ssh ubuntu@<IP> -i aquila_pk.pem

# Cleaning up AWS Resources
ansible-playbook 3-destroy/playbook.yml -i terraform/blockchain-node/hosts
```