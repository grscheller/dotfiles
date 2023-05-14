function rc --description 'Resize linux console for gauss17 external monitor'
    test $TERM = linux; and stty rows 45 columns 160
end
