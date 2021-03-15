USE [master]
GO
/****** Object:  Database [ChatAppDB]    Script Date: 1/21/2021 6:30:23 PM ******/
CREATE DATABASE [ChatAppDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ChatAppDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2018\MSSQL\DATA\ChatAppDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'ChatAppDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2018\MSSQL\DATA\ChatAppDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [ChatAppDB] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ChatAppDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ChatAppDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ChatAppDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ChatAppDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ChatAppDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ChatAppDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [ChatAppDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ChatAppDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ChatAppDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ChatAppDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ChatAppDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ChatAppDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ChatAppDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ChatAppDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ChatAppDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ChatAppDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ChatAppDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ChatAppDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ChatAppDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ChatAppDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ChatAppDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ChatAppDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ChatAppDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ChatAppDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [ChatAppDB] SET  MULTI_USER 
GO
ALTER DATABASE [ChatAppDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ChatAppDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ChatAppDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ChatAppDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ChatAppDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [ChatAppDB] SET QUERY_STORE = OFF
GO
USE [ChatAppDB]
GO
/****** Object:  Table [dbo].[Message]    Script Date: 1/21/2021 6:30:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Message](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FromUser] [int] NULL,
	[ToUser] [int] NULL,
	[Message] [nvarchar](max) NULL,
	[Date] [datetime] NULL,
 CONSTRAINT [PK_Messages] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 1/21/2021 6:30:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[Email] [nvarchar](50) NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserConnection]    Script Date: 1/21/2021 6:30:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserConnection](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[ConnectionId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_UserConnection] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Message]  WITH CHECK ADD  CONSTRAINT [FK_Messages_User] FOREIGN KEY([FromUser])
REFERENCES [dbo].[User] ([UserId])
GO
ALTER TABLE [dbo].[Message] CHECK CONSTRAINT [FK_Messages_User]
GO
ALTER TABLE [dbo].[Message]  WITH CHECK ADD  CONSTRAINT [FK_Messages_User1] FOREIGN KEY([ToUser])
REFERENCES [dbo].[User] ([UserId])
GO
ALTER TABLE [dbo].[Message] CHECK CONSTRAINT [FK_Messages_User1]
GO
ALTER TABLE [dbo].[UserConnection]  WITH CHECK ADD  CONSTRAINT [FK_UserConnection_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserId])
GO
ALTER TABLE [dbo].[UserConnection] CHECK CONSTRAINT [FK_UserConnection_User]
GO
USE [master]
GO
ALTER DATABASE [ChatAppDB] SET  READ_WRITE 
GO
