.PHONY: all clean

PARTIALS:= partial/partial01-broken.yaml partial/partial01.yaml partial/partial02-broken.yaml partial/partial02.yaml partial/partial03.yaml partial/partial04.yaml partial/partial05.yaml partial/partial06-broken.yaml partial/partial06.yaml partial/partial07.yaml partial/partial08.yaml partial/partial09.yaml partial/partial10.yaml partial/partial11.yaml partial/partial12.yaml
SLIDES := \
	slides/acknowledgements.md \
	slides/elearning.md \
	slides/introduction.md \
	slides/what_is_heat.md \
	slides/this_workshop.md \
	slides/services_and_architecture.md \
	slides/anatomy_of_a_heat_template.md \
	slides/overview.md \
	slides/command_line_heat_client_1.md \
	slides/command_line_heat_client_2.md \
	slides/heat_resources_an_example.md \
	slides/heat_functions.md \
	slides/hands_on_creating_a_heat_stack.md \
	slides/preparations.md \
	slides/a_minimal_template.md \
	slides/error_1_heat_template_version.md \
	slides/adding_parameters_to_your_template.md \
	slides/error_2_tabs_versus_spaces.md \
	slides/creating_a_network.md \
	slides/creating_a_subnet.md \
	slides/a_port_on_your_network.md \
	slides/creating_an_instance.md \
	slides/error_4_ssh_key_not_found.md \
	slides/error_5_no_valid_host_was_found.md \
	slides/attempt_to_associate_a_floating_ip.md \
	slides/error_6_external_network_not_reachable.md \
	slides/creating_a_router.md \
	slides/adding_a_routerinterface.md \
	slides/associating_a_floating_ip.md \
	slides/error_7_floating_ip_unreachable.md \
	slides/security_groups_to_the_rescue.md \
	slides/error_8_security_group_not_associated.md \
	slides/port_revisited.md \
	slides/outputs_whats_my_floating_ip.md \
	slides/error_9_cant_delete_stack.md \
	slides/cloud_config.md \
	slides/wait_condition.md

all: presentation.odp presentation.pdf transcript.txt partial $(PARTIALS)

slides.md: $(SLIDES)
	cat $(SLIDES) > $@

presentation.odp: slides.md	template.odp
	odpdown \
	-p 2 \
	--content-master No-Logo_20_Content \
	--break-master Break \
	slides.md template.odp presentation.odp

presentation.pdf: presentation.odp
	libreoffice --convert-to pdf $<

clean:
	rm -f presentation.odp
	rm -f slides.md
	rm -rf partial/0* partial/partial11.yaml partial/partial12.yaml

transcript.txt: slides.md
	bin/htmlcomments slides.md > transcript.txt

partial:
	mkdir partial

partial/partial01-broken.yaml: snippets/with-errors/01*
	cat $^ > $@
partial/partial01.yaml: snippets/without-errors/01-*
	cat $^ > $@
partial/partial02-broken.yaml: partial/partial01.yaml snippets/with-errors/02-*
	cat $^ > $@
partial/partial02.yaml: partial/partial01.yaml snippets/without-errors/02-*
	cat $^ > $@
partial/partial03.yaml: partial/partial02.yaml snippets/without-errors/03-*
	cat $^ > $@
partial/partial04.yaml: partial/partial03.yaml snippets/without-errors/04-*
	cat $^ > $@
partial/partial05.yaml: partial/partial04.yaml snippets/without-errors/05-*
	cat $^ > $@
partial/partial06-broken.yaml: partial/partial05.yaml snippets/without-errors/09-*
	cat $^ > $@
partial/partial06.yaml: partial/partial05.yaml snippets/without-errors/06-*
	cat $^ > $@
partial/partial07.yaml: partial/partial06.yaml snippets/without-errors/07-*
	cat $^ > $@
partial/partial08.yaml: partial/partial07.yaml snippets/without-errors/08-*
	cat $^ > $@
partial/partial09.yaml: partial/partial08.yaml snippets/without-errors/09-*
	cat $^ > $@
partial/partial10.yaml: partial/partial09.yaml snippets/without-errors/10-*
	cat $^ > $@
partial/partial11.yaml: $(sort $(wildcard snippets/without-errors/0[1-4]-* snippets/without-errors/11-* snippets/without-errors/0[6-9]-* snippets/without-errors/10-*))
	cat $^ > $@
partial/partial12.yaml: partial/partial11.yaml snippets/without-errors/12-*
	cat $^ > $@
