# QuickWash Laundry Booking System

QuickWash Laundry Booking System is a Java JSP/Servlet web application for managing laundry service bookings. It supports customer registration and booking, vendor availability and order handling, admin management, contact messages, authentication, and role-based dashboards.

## Technologies Used

- Java
- Jakarta Servlet
- JSP
- MySQL
- Tomcat
- Custom CSS

## Database

Database name:

```sql
laundry_booking_system
```

Database setup:

1. Create a MySQL database named `laundry_booking_system`.
2. Import `database/schema.sql` into MySQL.
3. Update database credentials in `src/dao/DBConnection.java` if your local MySQL username or password is different.

## Tomcat Setup

Deploy the project on Apache Tomcat with this context path:

```text
/LaundryBookingSystem
```

Main URL:

```text
http://localhost:8080/LaundryBookingSystem/
```

## Test Login Accounts

Admin:

```text
admin@quickwash.com / admin123
```

User:

```text
susmita@example.com / user123
```

Vendor:

```text
nischal@gmail.com / vendor123
```

Alternative vendor account if linked:

```text
vendor@quickwash.com / vendor123
```

## Main Features

- Registration and login
- Role-based dashboards
- Admin vendor, service, and user management
- Vendor verification and approval
- User laundry booking
- Vendor order status update
- Contact form
- Error pages
- Password hashing
- Session and filter authentication

## Project Structure

```text
database/       MySQL schema
src/controller/ Servlet controllers
src/dao/        Database access classes
src/filter/     Authentication filter
src/model/      Java model classes
src/util/       Utility classes
web/            JSP pages, CSS, images, WEB-INF configuration, and libraries
```
