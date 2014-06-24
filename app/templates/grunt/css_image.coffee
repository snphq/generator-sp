module.exports =
  css_image:
    dist:
      files:[
        cwd:"app/images/"
        src: "**/*.{png,jpg,gif,jpeg}"
        dest: "app/styles/vendor/_img.scss"
      ]
      options:
        prefix:"img_",
        images_path:"../images"
