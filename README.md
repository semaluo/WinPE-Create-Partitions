# MDT-ZTIDiskpart

For proper usage review
https://winpeguy.wordpress.com/2015/07/09/partitions-modifying-mdt-to-support-custom-partitioning/

MDT 2013 ZTIDiskpart.wsf
Modified MDT 2013 ZTIDiskpart.wsf file
Rename to 'ZTIDiskpart.wsf' and replace the one in your MDT Scripts directory

MDT 2013 ZTIDiskpart - Default.wsf
Original MDT 2013 ZTIDiskpart.wsf file

20150710
Updated script to allow a default of 984 MB but allow the BdeDriveSize Property to be set in CustomSettings.ini to override this.
Example:  BdeDriveSize = 800