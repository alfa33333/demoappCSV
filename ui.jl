heading("CSV Analysis")
 row([
    cell( 
        [
        textfield("Provide your name:", :text1),
        p("The lenght of Characters random numbers is {{lengthWords}}")
        ])
    cell( 
        [
        textfield("Provide some number:", :text2),
        p("The lenght of Characters random numbers is {{lengthWords2}}")
        ])
    cell( 
        [
            Stipple.select(:Select_fruit, options = :Select_fruit_list, label = "Select Fruits")
        ])
 ])

 row(
    [
        btn("Send", var"icon-right" = "send", color = "secondary", class = "q-mr-sm", @click(:Button_process))
    ]
 )


 row([
    cell(class="col-md-12", 
          [
          h1("Data Analysis")
          ])
      cell(class="col-md-12", 
          [
          uploader( multiple = true,
              accept = ".csv",
              maxfilesize = 1024*1024*1, # bytes
              maxfiles = 3,
              autoupload = true,
              hideuploadbtn = false,
              label = "Upload datasets",
              nothumbnails = true,
              style="max-width: 95%; width: 95%; margin: 0 auto;",
              @on("rejected", :rejected),
              @on("uploaded", :uploaded)
              )

          ])
 ])

 row([
     cell(
          class="st-module",
          [
           h6("File")
           Stipple.select(:selected_file; options=:upfiles)
          ]
         )
     cell(
          class="st-module",
          [
           h6("Column")
           Stipple.select(:selected_column; options=:columns)
          ]
         )
    ])

row([
    cell(
            class="st-module",
            [
            h5("Histogram")
            plot(:trace, layout=:layout)
            ]
        )
    ])