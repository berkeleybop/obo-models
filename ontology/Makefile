merged.owl: ontids.yml
	./ontology-maker.pl ontids.yml

merged.obo: merged.owl
	owltools $< -o -f obo --no-check $@

clean:
	rm target/* stage/*
