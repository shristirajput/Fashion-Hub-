# FashionHub - Smart Fashion Marketplace

FashionHub is a complete Java Full Stack web application built using MVC Architecture. It functions as a smart fashion marketplace with both new and used product buying/selling features.

## Technologies Used
- **Backend:** Java 11, Servlets, JSP
- **Frontend:** HTML5, CSS3, JavaScript, JSTL
- **Database:** MySQL 8+
- **Architecture:** MVC (Model-View-Controller)
- **Server:** Apache Tomcat 9+
- **Build Tool:** Maven

## Project Features
1. **User Authentication:** Login, Registration, Session Management, Password Hashing (SHA-256).
2. **Product Management:** Add, View, and Search products by Category.
3. **Shopping Cart:** Add/Remove items, update quantities, and checkout.
4. **Virtual Wallet:** Add funds and view transaction history. Wallet balance is used for checkout.
5. **Used Products:** Users can list their used clothes for sale. These require Admin approval.
6. **Admin Dashboard:** Approve/Reject used products, view overall metrics.

---

## Setup Instructions

### Prerequisites
1. **Java Development Kit (JDK) 11 or higher** installed.
2. **Apache Tomcat 9.0+** installed and configured.
3. **MySQL Server 8.0+** installed and running.
4. **Maven** installed (or an IDE with built-in Maven support like IntelliJ IDEA or Eclipse).

### Step 1: Database Setup
1. Open your MySQL client (e.g., MySQL Workbench, phpMyAdmin, or CLI).
2. Run the `database.sql` script located in the root of the project to create the database schema and insert sample data.
   ```sql
   source C:/FashionHub/database.sql;
   ```
3. *Note:* If your MySQL root user password is NOT `root`, update the `PASSWORD` field in `src/main/java/com/fashionhub/util/DBConnection.java`.

### Step 2: Build and Deploy using Maven
This project uses Maven to handle dependencies (Servlet API, JSP API, MySQL Connector).

**Option A: Using an IDE (Eclipse/IntelliJ)**
1. Open your IDE and select **Import Project** or **Open**.
2. Select the `c:\FashionHub` directory (where the `pom.xml` is located).
3. Let the IDE resolve the Maven dependencies.
4. Add your Apache Tomcat Server to the IDE.
5. Run the project on the Tomcat Server. The IDE will automatically build the WAR and deploy it.

**Option B: Using Command Line**
1. Open a terminal and navigate to the project directory:
   ```bash
   cd c:\FashionHub
   ```
2. Build the WAR file:
   ```bash
   mvn clean package
   ```
3. Copy the generated `FashionHub-1.0-SNAPSHOT.war` from the `target/` directory to your Tomcat `webapps/` directory.
   ```bash
   copy target\FashionHub-1.0-SNAPSHOT.war <TOMCAT_HOME>\webapps\FashionHub.war
   ```
4. Start Tomcat.

### Step 3: Access the Application
1. Open your web browser and navigate to:
   `http://localhost:8080/FashionHub/`
2. **Sample Accounts:**
   - **Admin:** Email: `admin@fashionhub.com`, Password: `admin123`
   - **User:** Email: `john@example.com`, Password: `user123`

## Directory Structure
- `src/main/java/`: Contains Controllers (Servlets), Models (JavaBeans), DAOs, and Utilities.
- `src/main/webapp/`: Contains JSP pages, CSS styles, and `WEB-INF/web.xml`.
- `pom.xml`: Maven configuration file.
- `database.sql`: MySQL schema and dummy data.

## Site Rating
**Current Rating: 7/10**
- Functional completeness (checkout works, but UI is basic). Needs responsive design, search, and pagination. Code quality is decent but lacks BCrypt and complete cart validation.
