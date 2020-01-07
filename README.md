My presentation on PDFKit from 360iDev 2019, along with sample code.

The video recording of my talk is now in this repo.  The same video is also available online at https://vimeo.com/359818794 and https://www.youtube.com/watch?v=rdDJI60YGA8.

The sample app is a very fake ticket sales app for a very fake band named Mitch and the Memory Leakers, known as the Second Best Apple Developer Rock n Roll Band.  (The best, of course, [James Dempsey and the Breakpoints](https://jamesdempsey.net/)!)  The concept is that you're tasked with writing the band's app, with the focus on ticket sales.  A designer has given you a PDF template.  The user will purchase a ticket, and the app needs to generate a PDF based on the template but adding the user's name, a trackable link to the band's web site (the user's name appended to the URL), and a QR code of the user's name.

The code is intentionally simplified, and contains stuff you shouldn’t do in real code, like force unwraps.

I also realized the sample project is iPad only. I’ll fix that so it builds for iPhone shortly. There’s nothing iPad specific in PDFKit; I was just lazy when making the Storybord.

I make no claims to...anything. I think the app functions as described above, but it might not. Who knows. It served its function as an app to demo capabilities of PDFKit as it exists in August, 2019.

The presentation file is in this repo, both as Keynote and PDF files.  I'll add the video recording once released.

I'll guess the best license to use is the MIT License, so that's the license. Please make use of the sample code to write your PDFKit app, but please test your own app thoroughly. Feel free to credit me if you use my code (or just find it helpful), but that's not at all necessary. If you find any glaring errors related to PDFKit feel free to create an issue, send a note, or whatever you'd like. If you find any errors in the rest of the app it's probably best to keep that to yourself as the app isn't otherwise much of an example of anything.

This is Copyright (c) 2019 Mitch Cohen, but as per the above you can use this for whatever you want without permission from me.

Have a nice day.
