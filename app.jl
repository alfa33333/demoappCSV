using GenieFramework, DataFrames, CSV, PlotlyBase
@genietools


const FILE_PATH = joinpath("public", "uploads")
mkpath(FILE_PATH)

@app begin   
# Logic goes here
    ## data input
    @in text1 = ""
    @out lengthWords = ""
    @onchange text1 begin
        lengthWords = string(length(text1))
    end

    @in text2 = ""
    @out lengthWords2 = ""
    @onchange text2 begin
        lengthWords2 = string(length(text2))
    end

    @in Select_fruit = [""]
    @out Select_fruit_list = ["Apple", "Banana", "Orange", "Pineapple"]


    ## data analysis
    @in selected_file = ""
    @in selected_column = ""
    @out columns = []
    @out upfiles = readdir(FILE_PATH)
    @out trace = [histogram()]
    @out layout = PlotlyBase.Layout(yaxis_title_text="Count",xaxis_title_text="Value")
    @private data = DataFrame()

    ## button 
    @in Button_process = false
    @onbutton Button_process begin
        @info "Button was clicked"
        sntdf = DataFrame(text1 = text1, text2 = text2, Select_fruit = Select_fruit)
        CSV.write("public/uploads/df.csv", sntdf)
        upfiles = readdir(FILE_PATH)
        notify(__model__, "Information was submitted successfully!")
    end
    

    @onchange fileuploads begin
        if ! isempty(fileuploads)
            @info "File was uploaded: " fileuploads
            filename = fileuploads["name"]
            println(fileuploads["path"])
            ## Temporary workaround for windows error only!
            tempPath =  joinpath(splitdir(tempname())[1], split(fileuploads["path"], "Temp")[2])
            println(tempPath)
            try
                isdir(FILE_PATH) || mkpath(FILE_PATH)
                mv(tempPath, joinpath(FILE_PATH, filename), force=true)
            catch e
                @error "Error processing file: $e"
                notify(__model__,"Error processing file: $(fileuploads["name"])")
            end

            fileuploads = Dict{AbstractString,AbstractString}()
        end
        upfiles = readdir(FILE_PATH)
    end
    @event uploaded begin
        @info "uploaded"
        notify(__model__, "File was uploaded")
    end
    @event rejected begin
        @info "rejected"
        notify(__model__, "Please upload a valid file")
    end

    @onchange isready,selected_file begin
        if ! isempty(selected_file)
            @info "Selected file: $selected_file"
            data = CSV.read(joinpath(FILE_PATH, selected_file), DataFrame)
            columns = names(data)
        end
    end

    @onchange isready, selected_column begin
        if ! isempty(selected_column)
            trace = [histogram(x=data[!, selected_column])]
        end
    end

end

@page("/", "ui.jl")