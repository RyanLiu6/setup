if [[ "$OSTYPE" == "linux-gnu" ]]; then
        # ...
	echo "linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
	echo "Mac"
fi
