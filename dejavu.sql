SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `dejavu` DEFAULT CHARACTER SET utf8 ;
USE `dejavu` ;

-- -----------------------------------------------------
-- Table `dejavu`.`dejavu`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `dejavu`.`dejavu` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `user` VARCHAR(45) NULL ,
  `date_created` DATETIME NULL ,
  `date_resolved` DATETIME NULL ,
  `resolved` TINYINT(1) NULL DEFAULT false ,
  `description` TEXT NULL ,
  `solution` TEXT NULL ,
  `labels` TEXT NULL ,
  PRIMARY KEY (`id`) ,
  FULLTEXT INDEX `index2` (`description` ASC) ,
  FULLTEXT INDEX `index3` (`solution` ASC) ,
  FULLTEXT INDEX `index4` (`labels` ASC) )
ENGINE = MyISAM;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
