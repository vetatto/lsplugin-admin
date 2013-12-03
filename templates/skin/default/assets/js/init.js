/**
 * LiveStreet CMS
 * Copyright © 2013 OOO "ЛС-СОФТ"
 *
 * ------------------------------------------------------
 *
 * Official site: www.livestreetcms.com
 * Contact e-mail: office@livestreetcms.com
 *
 * GNU General Public License, version 2:
 * http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
 *
 * ------------------------------------------------------
 *
 * @link http://www.livestreetcms.com
 * @copyright 2013 OOO "ЛС-СОФТ"
 * @author Serge Pustovit (PSNet) <light.feel@gmail.com>
 *
 */

jQuery(document).ready(function($) {

	/**
	 * Popovers
	 */
	$('.js-popover-default').tooltip({
		useAttrTitle: false,
		trigger: 'click',
		classes: 'tooltip-light'
	});

	$('[data-type=tab]').tab();
	
	$('.js-alert').alert();

	/**
	 * Modals
	 */
	$('.js-modal-default').modal();


	/**
	 * Datepicker
	 */
	$('.date-picker').datepicker();


	/**
	 * Datepicker with php date format
	 */
	$('.date-picker-php').datepicker({
		/*
		 	формат даты изменен для удобства работы с ней на стороне php
		 */
		dateFormat: 'yy-mm-dd'
	});


	/**
	 * Dropdowns
	 */
	$('.js-dropdown').dropdown({
	    position: {
	        my: "right+10 top+10",
	        at: "right bottom",
	        collision: "flipfit flip"
		},
		body: true
	});
	/*
		используется для списка сортировок столбца таблицы
	 */
	$('.js-dropdown-left-bottom').dropdown({
		position: {
			my: "left-10 top+10",
			at: "left bottom",
			collision: "flipfit flip"
		},
		body: true
	});

	/* Юзербар */
	$('.js-dropdown-userbar').dropdown({
	    position: {
	        my: "right top",
	        at: "right bottom",
	        collision: "flipfit flip"
		},
		body: true,
		beforeshow: function (e, dropdown) {
			// Задаем минимальную ширину меню
			var toggleWidth = dropdown.element.outerWidth();
			dropdown._target.css('width', toggleWidth > 200 ? toggleWidth : 'auto' );
		}
	});


	/**
	 * Tooltips
	 */
	$('.js-tooltip').tooltip();


	/**
	 * Autocomplete
	 */
	ls.autocomplete.add($(".autocomplete-users"), aRouter['ajax']+'autocompleter/user/', false);


	/**
	 * Scroll
	 */
	$(window)._scrollable();


	/**
	 * Code highlight
	 */
	prettyPrint();

	/*
		вопрос при активации элементов интерфейса
	 */
	$ ('.ls-admin .question').bind ('click.admin', function() {
		sQ = $ (this).attr ('data-question-title') ? $ (this).attr ('data-question-title') : 'Ok?';
		if (!confirm (sQ)) return false;
	});

	/**
	 * Custom checkboxes and radios
	 */
	$('input').iCheck({
		labelHover: false,
		cursor: true,
		checkboxClass: 'icheckbox_minimal',
		radioClass: 'iradio_minimal'
	});

	/* Выделение всех чексбоксов */
	$('.js-check-all').on('ifChanged', function () {
		var checkAll = $(this);
		var checkboxes = $( '.' + checkAll.data('checkboxes-class') );

		if ( checkAll.is(':checked') ) checkboxes.iCheck('check'); else checkboxes.iCheck('uncheck');
	});


	/**
	 * Mobile navigation toggle
	 *
	 * @template layouts/layout.base.tpl
	 * @template blocks/block.nav.tpl
	 */
	var $navMain = $('.js-nav-main');

	$('.js-nav-main-toggle').on('click', function () {
		$navMain[ $navMain.is(':visible') ? 'removeClass' : 'addClass' ]('is-open');
	});


	/**
	 * Main navigation
	 *
	 * @template navs/nav.main.tpl
	 */
	(function () {
		var cookieName = 'nav_main_items',
			cookie = $.cookie(cookieName),
			items = cookie ? cookie.split(',') : [];

		$navMain.find('.js-nav-main-item-root > a').on('click', function (e) {
			var $element = $(this).closest('li'),
				id = $element.data('item-id'),
				isOpen = $element.hasClass('open'),
				cookie = $.cookie(cookieName),
				items = cookie ? cookie.split(',') : [];

			if (isOpen) {
				// Remove
				var index = items.indexOf(id + "");
				if (index !== -1) items.splice(index, 1);
				$.cookie(cookieName, items.join(','), { path: '/' });

				$element.removeClass('open');
			} else {
				// Add
				items.push(id);
				$.cookie(cookieName, items.join(','), { path: '/' });

				$element.addClass('open');
			}

			e.preventDefault();
		});

		// Open items
		$('.js-nav-main-item-root').each(function () {
			var $element = $(this),
				id = $element.data('item-id');

			if ( items.indexOf(id + "") != -1 ) $element.addClass('open');
		});
	})();
});