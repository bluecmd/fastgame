all:
	(cd src/fastgame/; /usr/lib/dart/bin/pub build)

deploy:
	appcfg.py update app.yaml backend.yaml

deploy-rtcbridge:
	gcloud --project bluecmd0 preview app deploy rtcbridge.yaml
