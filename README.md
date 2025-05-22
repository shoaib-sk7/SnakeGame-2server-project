🐍 Snake Game - 3-Tier Architecture
A cloud-native, container-ready Snake Game project built using HTML, PHP, MySQL, and hosted on AWS EC2 with Auto Scaling, Application Load Balancer, and RDS.


📐 Architecture

Frontend: Static files served by NGINX on public EC2 instances

Backend: PHP APIs hosted on private EC2 instances behind an ALB

Database: MySQL managed by Amazon RDS in private subnet

Networking: VPC with public/private subnets, security groups, and IAM roles



🚀 Tech Stack

Frontend: HTML, JavaScript

Backend: PHP (Apache2)

Database: MySQL (Amazon RDS)

Infrastructure: Terraform, AWS (EC2, ALB, RDS, VPC)

Automation: Bash scripting, NGINX, Apache2


🎯 Features

Fully responsive and interactive Snake game UI

Real-time leaderboard with persistent score storage

Secure backend API layer separated from frontend via reverse proxy

Scalable architecture with Auto Scaling Groups and Load Balancers

Automated provisioning and deployment scripts for repeatability


🛠️ Common Issues & Solutions

| Issue                                   | Cause                                            | Solution  |
|----------------------------------------|--------------------------------------------------|----------------------------------------------------------------------|
| Leaderboard scores not showing         | Backend-DB connection misconfiguration           | Verify DB credentials; run `init.sql` to create tables & data|            
| Apache2 backend server not serving PHP | Missing PHP module or incorrect config           | Install PHP, enable modules with `sudo apt install php libapache2-mod-php|
| NGINX shows 404 for frontend files     | Incorrect root path or missing files             | Ensure frontend files are copied to `/var/www/html`; configure root path|
| MySQL authentication error             | Wrong username/password or host denied           | Double-check user, password, host permissions; allow access from host|
| Terraform apply fails                  | Invalid config or insufficient permissions       | Validate Terraform configs; ensure AWS credentials are correct       |
| Proxy errors / Backend API unreachable | Incorrect NGINX `proxy_pass` or backend IP       | Verify backend IP and `proxy_pass` URL; restart NGINX                |


🎯 Features

Fully responsive and interactive Snake game UI

Real-time leaderboard with persistent score storage

Secure backend API layer separated from frontend via reverse proxy

Scalable architecture with Auto Scaling Groups and Load Balancers

Automated provisioning and deployment scripts for repeatability


⭐ Acknowledgments

Inspired by classic Snake games.

Deployed using AWS services for scalable architecture.

Infrastructure managed with Terraform for reproducibility.


📬 Contact

Shoaib SK
📧 shoaibkhalifahere@gmail.com



