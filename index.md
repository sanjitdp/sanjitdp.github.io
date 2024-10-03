---
layout: default
title: "Sanjit Dandapanthula"
---

<style>
    #headerim {
        display: flex;
        flex-direction: column; /* Arrange items in a column */
        align-items: center; /* Center the image and caption horizontally */
        text-align: center; /* Center the text inside the container */
    }

    #im {
        display: block;
        margin: 0 auto; /* Center the image horizontally */
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3); /* Add a subtle shadow */
        border-radius: 8px; /* Optional: Add rounded corners */
        filter: brightness(60%);
    }

    #headerim a {
        margin: 0 1rem; /* Add horizontal space between links */
        color: #333; /* Adjust the color of the icons */
        font-size: 28px; /* Adjust the size of the icons */
        &:hover {
            text-decoration: none;
            opacity: 0.8;
        }
    }
</style>

<div id='headerim'>
<img id='im' src="/assets/images/sanjit.jpg">
<p>
    <a href="https://github.com/yourusername" target="_blank"><i class="fab fa-github"></i></a>
    <a href="https://www.linkedin.com/in/yourprofile" target="_blank"><i class="fab fa-linkedin"></i></a>
    <a href="mailto:your-email@example.com"><i class="fas fa-envelope"></i></a>
</p>
</div>

<div id='index-intro-text' markdown='1'>

## About me

<p markdown='1'>
I'm a first year PhD student at Carnegie Mellon University studying [statistics](https://www.cmu.edu/dietrich/statistics-datascience/index.html) and [machine learning](https://www.ml.cmu.edu/).
</p>

---

<div id='index-main-text' markdown='1'>

## Research

<p markdown="1">
I'm currently interested in studying the theory of statistics and machine learning. More details to come.
</p>
</div> 
</div>