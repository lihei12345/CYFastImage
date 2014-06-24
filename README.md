CYFastImage
===========

A iOS library for displaying web images by Swift. It's inspired by SDWebImage and Volley. I tried fulfilling namespace feature in Swift by using nest types and extensions, accomplishing singleton by type properties, using custom NSOperation to do simple network quque, and learning lovely and great closures to remove delegates !!! There are many things need to be done, such as runloop in separate thread for NSURLConnection, using NSURLSession instead of NSURLConnection, and support gifs/png/webp format.

Forgive my poor Chinese English! And CY is short for wife's name!

Example
========
	imageView.setImageURL("http://g.hiphotos.baidu.com/image/pic/item/dc54564e9258d1097dec49e3d358ccbf6c814d50.jpg", placeHolderImage: UIImage(named: "default_placeholder.png"))