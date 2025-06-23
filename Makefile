dev:
	@echo -e "\e[34m[Flutter]\e[0m Starting innsikt..."
	@flutter run -d windows
json:
	@echo -e "\e[33m[JSON]\e[0m Building Mappers..."
	@dart run build_runner build
generate-seats:
	@echo -e "\e[33m[Seats]\e[0m Generating seating chart spots..."
	@dart run lib/src/features/stortinget/presentation/case_view/seating_chart_spots.dart