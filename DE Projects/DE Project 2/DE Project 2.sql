use Project_2
-- Create User Table
CREATE TABLE [User] (
    User_ID VARCHAR(50) PRIMARY KEY
);

-- Create Product Table
CREATE TABLE Product (
    Product_ID VARCHAR(50) PRIMARY KEY,
    Category VARCHAR(100),
    Price DECIMAL(10,2),
    Discount INT
);

-- Create Purchase Table
CREATE TABLE Purchase (
    Purchase_ID VARCHAR(50) PRIMARY KEY,
    User_ID VARCHAR(50),
    Product_ID VARCHAR(50),
    Payment_Method VARCHAR(100),
    Purchase_Date DATE,
    Final_Price DECIMAL(10,2),
    CONSTRAINT FK_User_Purchase FOREIGN KEY (User_ID)
        REFERENCES [User](User_ID),
    CONSTRAINT FK_Product_Purchase FOREIGN KEY (Product_ID)
        REFERENCES Product(Product_ID)
);
