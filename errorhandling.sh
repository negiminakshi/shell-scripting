#!/bin/bash

create_dir() {
	mkdir demo 

}

if ! create_dir; then
	echo "dir already exists"
	exit 1

fi

echo "this code will not run becoz code is interpreted"
