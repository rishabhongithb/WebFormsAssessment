CREATE TABLE [dbo].[Employees] (
    [Name]          VARCHAR (100) NOT NULL,
    [DateOfBirth]   DATE          NOT NULL,
    [MobileNumber]  VARCHAR (15)  NOT NULL UNIQUE,
    [AadhaarNumber] VARCHAR (20)  NOT NULL UNIQUE,
    [PANNumber]     VARCHAR (20)  NULL,
    [Country]       VARCHAR (50)  NOT NULL,
    [State]         VARCHAR (50)  NOT NULL,
    [City]          VARCHAR (50)  NOT NULL,
    [Gender]        VARCHAR (10)  NULL
);

CREATE PROCEDURE SaveOrUpdateEmployee
    @MobileNumber VARCHAR(15),
    @Name VARCHAR(100),
    @DateOfBirth DATE,
    @AadhaarNumber VARCHAR(20),
    @PANNumber VARCHAR(20),
    @Country VARCHAR(50),
    @State VARCHAR(50),
    @City VARCHAR(50),
    @Gender VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 FROM Employees
        WHERE AadhaarNumber = @AadhaarNumber AND MobileNumber <> @MobileNumber
    )
    BEGIN
        RAISERROR('Aadhaar Number already exists.', 16, 1)
        RETURN
    END

    IF EXISTS (
        SELECT 1 FROM Employees WHERE MobileNumber = @MobileNumber
    )
    BEGIN
        UPDATE Employees
        SET [Name] = @Name,
            DateOfBirth = @DateOfBirth,
            AadhaarNumber = @AadhaarNumber,
            PANNumber = @PANNumber,
            Country = @Country,
            [State] = @State,
            City = @City,
            Gender = @Gender
        WHERE MobileNumber = @MobileNumber
    END
    ELSE
    BEGIN
        INSERT INTO Employees
        (Name, DateOfBirth, MobileNumber, AadhaarNumber, PANNumber, Country, State, City, Gender)
        VALUES
        (@Name, @DateOfBirth, @MobileNumber, @AadhaarNumber, @PANNumber, @Country, @State, @City, @Gender)
    END
END
