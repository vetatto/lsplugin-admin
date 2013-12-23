{**
 * Сортировка по полям с учетом фильтра
 *
 * @param string $sCellClassName Имя класса тега th таблицы ('name')
 * @param mixed  $mSortingOrder  Имя поля для сортировки текущей ячейки ('u.user_login') может быть массивом, если нужно чтобы выводился выпадающий список по какому полю сортировать
 * @param mixed  $mLinkHtml      Отображаемый хтмл ссылки сортировки ('имя') может быть массивом, 
 *                               если нужно чтобы выводился выпадающий список по какому полю сортировать (соответствие текстовки каждому полю из $mSortingOrder)
 * @param string $sBaseUrl       Базовый путь ссылки для сортировки ({router page='admin/users/list'})
 * @param string $sDropDownHtml  Хтмл ссылки дропдауна, нужен в том случае, если в указаном столбце несколько выводимых полей (они должны быть указаны в массиве $mSortingOrder),
 *                               то тогда при нажатии на шапку столбца будет показан выпадающий список полей, по которым можно сортировать таблицу.
 * 	                             Если поле одно, то указывать данный параметр не нужно
 *
 * Также уже должны существовать вспомогательные переменные:
 *
 * @param string $sReverseOrder  Обратная сортировка от текущей (или той, что идет по-умолчанию в случае отсутствия выбранной)
 * @param string $sOrder         Текущее имя поля для сортировки
 * @param string $sWay           Текущее направление сортировки (или та, что идет по-умолчанию в случае отсутствия выбранной)
 *}

<th class="cell-{$sCellClassName}">
	{if !is_array($mSortingOrder)}
		{$mSortingOrder = array($mSortingOrder)}
	{/if}

	{if !is_array($mLinkHtml)}
		{$mLinkHtml = array($mLinkHtml)}
	{/if}

	{* Если ссылок больше одной, то тогда их нужно выводить в выпадающем списке *}
	{if count($mSortingOrder) > 1}
		{$bDropDownMenu = true}

		{* Кнопка выпадающего списка *}
		<a href="#" class="link-dotted js-dropdown-left-bottom" data-dropdown-target="dropdown-sorting-table-menu-{$sCellClassName}">
			{* Многоточие будет подталкивать к мысли что это выпадающее меню со множеством сортировок *}
			{$sDropDownHtml}&hellip;

			{**
			 * Вывод стрелки сортировки если текущая сортировка из этого выпадающего списка сортировок, 
			 * нужно для того, чтобы легко ориентироваться включена ли сортировка в таблице и в каком именно столбце
			 *}
			{if in_array($sOrder, $mSortingOrder)}
				{if $sWay == 'asc'}
					<i class="icon-sort-asc"></i>
				{elseif $sWay == 'desc'}
					<i class="icon-sort-desc"></i>
				{/if}
			{/if}
		</a>

		{* Начало контейнера списка сортировок *}
		<div class="dropdown-menu p15" id="dropdown-sorting-table-menu-{$sCellClassName}">
	{/if}

	{* Вывод полей для сортировки *}
	{foreach $mSortingOrder as $iKey=>$sSortingOrderItem}
		{* Указывает что сортировка активна по данном полю *}
		{$bSortedByCurrentField = $sOrder == $sSortingOrderItem}

		{* Направление сортировки для данного поля *}
		{$sWayForThisOrder = "{if $bSortedByCurrentField}{$sReverseOrder}{else}{$sWay}{/if}"}

		{* Чтобы ссылки в выпадающем списке были одна под одной *}
		{if $bDropDownMenu}
			<div class="{if !$sSortingOrderItem@last}mb-10{/if}">
		{/if}

		{* Ссылка смены сортировки *}
		<a href="{$sBaseUrl}{request_filter
			name=array('order_field', 'order_way')
			value=array($sSortingOrderItem, $sWayForThisOrder)
		}" class="link-dotted">{$mLinkHtml[$iKey]}</a>

		{* Стрелка, указывающая направление сортировки *}
		{if $bSortedByCurrentField}
			{if $sWay == 'asc'}
				<i class="icon-sort-asc"></i>
			{elseif $sWay == 'desc'}
				<i class="icon-sort-desc"></i>
			{/if}
		{/if}

		{* / Чтобы ссылки в выпадающем списке были одна под одной *}
		{if $bDropDownMenu}
			</div>
		{/if}
	{/foreach}

	{* Конец контейнера списка *}
	{if $bDropDownMenu}
		</div>
	{/if}
</th>