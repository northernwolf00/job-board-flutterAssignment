const String mockJobsJson = '''
[
  {
    "id": "1",
    "title": "Senior Flutter Developer",
    "company": "TechCorp Inc.",
    "shortDescription": "Join our mobile team to build cutting-edge Flutter applications",
    "fullDescription": "We are looking for an experienced Flutter developer to join our dynamic team. You will be responsible for developing high-quality mobile applications using Flutter framework. The ideal candidate should have strong experience with Dart, state management, and mobile app architecture.",
    "location": "San Francisco, CA",
    "salary": "\$120,000 - \$150,000",
    "status": "open",
    "createdAt": "2024-01-15T10:00:00Z",
    "requirements": [
      "3+ years of Flutter development experience",
      "Strong knowledge of Dart programming language",
      "Experience with state management (BLoC, Provider, Riverpod)",
      "Knowledge of mobile app architecture patterns",
      "Experience with REST APIs and GraphQL"
    ]
  },
  {
    "id": "2",
    "title": "UI/UX Designer",
    "company": "Design Studio Pro",
    "shortDescription": "Create amazing user experiences for mobile and web applications",
    "fullDescription": "We are seeking a talented UI/UX Designer to create intuitive and visually appealing designs for our digital products. You will work closely with developers and product managers to deliver exceptional user experiences.",
    "location": "Remote",
    "salary": "\$80,000 - \$100,000",
    "status": "open",
    "createdAt": "2024-01-20T14:30:00Z",
    "requirements": [
      "3+ years of UI/UX design experience",
      "Proficiency in Figma, Sketch, or Adobe XD",
      "Strong portfolio demonstrating design skills",
      "Understanding of user-centered design principles",
      "Experience with mobile and web design"
    ]
  },
  {
    "id": "3",
    "title": "Backend Developer",
    "company": "CloudTech Solutions",
    "shortDescription": "Build scalable backend systems with modern technologies",
    "fullDescription": "Join our backend team to develop robust and scalable server-side applications. You will work with cloud technologies, microservices, and modern frameworks to build systems that power our applications.",
    "location": "New York, NY",
    "salary": "\$100,000 - \$130,000",
    "status": "closed",
    "createdAt": "2024-01-10T09:15:00Z",
    "requirements": [
      "4+ years of backend development experience",
      "Strong knowledge of Node.js or Python",
      "Experience with cloud platforms (AWS, GCP, Azure)",
      "Database design and optimization skills",
      "Microservices architecture experience"
    ]
  },
  {
    "id": "4",
    "title": "Product Manager",
    "company": "Innovation Labs",
    "shortDescription": "Lead product development and strategy for next-gen applications",
    "fullDescription": "We are looking for a Product Manager to drive the development of innovative products. You will work with cross-functional teams to define product requirements, roadmaps, and ensure successful product launches.",
    "location": "Austin, TX",
    "salary": "\$110,000 - \$140,000",
    "status": "open",
    "createdAt": "2024-01-25T16:45:00Z",
    "requirements": [
      "5+ years of product management experience",
      "Strong analytical and problem-solving skills",
      "Experience with agile development methodologies",
      "Excellent communication and leadership skills",
      "Technical background preferred"
    ]
  },
  {
    "id": "5",
    "title": "DevOps Engineer",
    "company": "Infrastructure Pro",
    "shortDescription": "Manage cloud infrastructure and deployment pipelines",
    "fullDescription": "Join our DevOps team to build and maintain scalable infrastructure solutions. You will be responsible for CI/CD pipelines, monitoring systems, and ensuring high availability of our applications.",
    "location": "Seattle, WA",
    "salary": "\$95,000 - \$125,000",
    "status": "open",
    "createdAt": "2024-02-01T11:20:00Z",
    "requirements": [
      "3+ years of DevOps experience",
      "Proficiency with Docker and Kubernetes",
      "Experience with CI/CD tools (Jenkins, GitLab CI)",
      "Cloud platform expertise",
      "Infrastructure as Code (Terraform, Ansible)"
    ]
  }
]
''';