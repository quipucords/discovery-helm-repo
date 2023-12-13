#
# Makefile for the downstream Discovery Helm Repo.
#

# helm package ../quipucords-helm-chart/discovery --destination ./charts
# cp ../quipucords-helm-chart/discovery/icon.png ./charts/discovery/
# helm repo index ./charts
#
# Let's grab the latest helm chart from the upstream repo

LATEST_HELM_CHART="https://github.com/quipucords/quipucords-helm-chart/archive/refs/heads/main.zip"
MAIN_HELM_CHART="helm-chart/quipucords-helm-chart-main/discovery"

all:	help

update:
	@echo "Updating the downstream Discovery helm repo using the latest upstream helm chart ..."
	mkdir -p charts/discovery
	rm -rf helm-chart
	mkdir -p helm-chart
	@echo "Pulling in the latest upstream helm chart ..."
	@cd helm-chart && curl -k -SL $(LATEST_HELM_CHART) --output helm-chart.zip && unzip -q helm-chart.zip
	@echo "Overlaying downstream template files ..."
	@cd overlays && tar cf - . | tar xvf - -C ../$(MAIN_HELM_CHART)/
	@echo "Updating upstream helm repo references to downstream ..."
	@sed -i "" "s/quipucords-helm-repo/discovery-helm-repo/" "$(MAIN_HELM_CHART)/Chart.yaml"
	helm package $(MAIN_HELM_CHART) --destination ./charts
	cp $(MAIN_HELM_CHART)/icon.png ./charts
	helm repo index ./charts

help:
	@echo "Makefile for the downstream Discovery Helm Repo."
	@echo ""
	@echo "Make targets:"
	@echo "  help    Shows this output."
	@echo "  update  Package the latest chart from quipucords-helm-chart and update the index."

