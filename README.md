# FashionHub

FashionHub is a full‑stack Java web marketplace built with **Servlets**, **JSTL**, and **MySQL**. It provides:

- Secure user authentication with **BCrypt** password hashing.
- Product listings, a used‑marketplace, and admin approval workflow.
- My Orders page, wallet balance, and profile management.
- Rating & review system for products.
- Modern UI with glass‑morphism inspired styling.

## Getting Started

1. Install Java 11+ and Maven.
2. Configure MySQL and import `src/main/resources/database.sql`.
3. Run `mvn clean package` and deploy the generated `target/FashionHub-1.0-SNAPSHOT.war` to Tomcat.

## Features
- BCrypt security
- Profile editing & password change
- Product rating & reviews
- Admin dashboard with live DB stats
- Pagination & filtering (TODO)
- Admin user management (TODO)

## Contributing
Feel free to open issues or submit pull requests. Use the standard Maven build process.
