<?php
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

/*
 *
 * Модуль работы с официальным каталогом плагинов для LiveStreet CMS
 *
 */

class PluginAdmin_ModuleCatalog extends Module {

	/*
	 * строка замены на код плагина в урле метода
	 */
	const PLUGIN_CODE_PLACEHOLDER = '{plugin_code}';

	/*
	 * Префикс методов АПИ каталога
	 */
	const CALLING_METHOD_PREFIX = 'RequestDataFor';

	/*
	 * Базовый путь к АПИ каталога
	 */
	private $sCatalogBaseApiUrl = null;

	/*
	 * Методы для работы с каталогом
	 */
	private $aCatalogMethodPath = array();

	/*
	 * Время жизни кеша для разных запросов
	 */
	protected $aCacheLiveTime = array();


	final public function Init() {
		$this->sCatalogBaseApiUrl = Config::Get('plugin.admin.catalog.base_api_url');
		$this->aCatalogMethodPath = Config::Get('plugin.admin.catalog.methods_pathes');
		$this->aCacheLiveTime = Config::Get('plugin.admin.catalog.cache_live_time');
	}


	/*
	 *
	 * --- АПИ ---
	 *
	 */

	/**
	 * Построить относительный путь к методу по коду плагина, группе методов и методе из указанной группы
	 *
	 * @param $sPluginCode		код плагина
	 * @param $sMethodGroup		группа методов
	 * @param $sMethod			метод группы
	 * @return mixed			строка с относительным путем к методу
	 */
	private function BuildMethodPathForPlugin($sPluginCode, $sMethodGroup, $sMethod) {
		return str_replace(self::PLUGIN_CODE_PLACEHOLDER, $sPluginCode, $this->aCatalogMethodPath[$sMethodGroup][$sMethod]);
	}


	/**
	 * Получить абсолютный путь к АПИ по коду плагина, группе методов и методе из указанной группы
	 *
	 * @param $sPluginCode		код плагина
	 * @param $sMethodGroup		группа методов
	 * @param $sMethod			метод группы
	 * @return mixed			строка с абсолютным путем к методу
	 */
	private function GetApiPath($sPluginCode, $sMethodGroup, $sMethod) {
		return $this->sCatalogBaseApiUrl . $this->BuildMethodPathForPlugin($sPluginCode, $sMethodGroup, $sMethod);
	}


	/**
	 * Обрабатывает все запросы к АПИ каталога
	 *
	 * @param string $sName		имя не обьявленного метода
	 * @param array  $aArgs		аргументы
	 * @return mixed
	 */
	public function __call($sName, $aArgs) {
		/*
		 * если это вызов АПИ
		 */
		if (strpos($sName, self::CALLING_METHOD_PREFIX) !== false) {
			/*
			 * убрать префикс
			 */
			$sName = str_replace(self::CALLING_METHOD_PREFIX, '', $sName);
			/*
			 * найти группу методов и сам метод
			 */
			list($sMethodGroup, $sMethod) = explode('_', func_underscore($sName), 2);

			/*
			 * добавить их в набор параметров
			 */
			$aArgsToSend = array_merge($aArgs ? $aArgs : array('no_plugin_code'), array($sMethodGroup, $sMethod));

			/*
			 * вернуть путь к методу
			 */
			return call_user_func_array(array($this, 'GetApiPath'), $aArgsToSend);
		} else {
			/*
			 * обычный вызов ядра
			 */
			return parent::__call($sName, $aArgs);
		}
	}


	/*
	 *
	 * --- Обработка и запросы по АПИ ---
	 *
	 */

	/**
	 * Получить ответ от сервера по обновлениям для всех или указанных плагинов
	 *
	 * @param array $aPlugins	массив сущностей плагинов для проверки, если не указать - будут проверены все плагины в системе
	 * @return mixed			массив ответа от сервера или строка ошибки соединения
	 */
	protected function GetUpdatesListForPlugins($aPlugins = array()) {
		/*
		 * если список проверяемых плагинов не указан - получить все плагины
		 */
		if (empty($aPlugins)) {
			$aPluginsInfo = $this->PluginAdmin_Plugins_GetPluginsList();
			$aPlugins = $aPluginsInfo['collection'];
		}
		if (!is_array($aPlugins)) {
			$aPlugins = (array) $aPlugins;
		}
		/*
		 * сформировать нужный массив для запроса
		 */
		$aRequestData = array('data' => $this->BuildPluginsRequestArray($aPlugins));
		/*
		 * получить полный урл для АПИ каталога по запросу последних версий плагинов
		 */
		$sApiUrl = $this->RequestDataForAddonsCheckVersion();
		/*
		 * запросить данные
		 */
		$aResponseAnswer = $this->PluginAdmin_Remoteserver_Send(array(
			PluginAdmin_ModuleRemoteserver::REQUEST_URL => $sApiUrl,
			PluginAdmin_ModuleRemoteserver::REQUEST_DATA => $aRequestData
		));
		/*
		 * если нет ошибок
		 */
		if ($aResponseAnswer[PluginAdmin_ModuleRemoteserver::RESPONSE_SUCCESS]) {
			/*
			 * вернуть массив данных
			 */
			return json_decode($aResponseAnswer[PluginAdmin_ModuleRemoteserver::RESPONSE_DATA], true);
		}
		/*
		 * вернуть текст ошибки
		 */
		return $aResponseAnswer[PluginAdmin_ModuleRemoteserver::RESPONSE_ERROR_MESSAGE];
	}


	/**
	 * Сформировать массив со списком кодов плагинов и их версиями
	 *
	 * @param $aPlugins		массив сущностей плагинов
	 * @return array
	 */
	protected function BuildPluginsRequestArray($aPlugins) {
		$aRequestData = array();
		foreach ($aPlugins as $oPlugin) {
			$aRequestData[] = array('code' => $oPlugin->getCode(), 'version' => $oPlugin->getVersion());
		}

		return $aRequestData;
	}


	/**
	 * Получение массива кодов плагинов, для которых есть обновления в каталоге
	 *
	 * @param array $aPlugins		массив сущностей плагинов для проверки, если нужно
	 * @return string|bool|array	массив кодов и версий плагинов с обновлениям, false если нет обновлений или строка ошибки
	 */
	public function GetPluginUpdates($aPlugins = array()) {
		/*
		 * послать запрос на сервер для получения списка обновлений
		 */
		$mData = $this->GetUpdatesListForPlugins($aPlugins);
		/*
		 * если получен ответ от сервера
		 */
		if (is_array($mData)) {
			/*
			 * если ошибка на стороне сервера
			 */
			if (isset($mData['bStateError']) and $mData['bStateError']) {
				/*
				 * вернуть её текст
				 */
				return $mData['sMsgTitle'] . ':' . $mData['sMsg'];
			}
			/*
			 * если передан список кодов плагинов, для которых есть обновления и их последние версии
			 */
			if (isset($mData['aData']) and is_array($mData['aData']) and count($mData['aData']) > 0) {
				/*
				 * формирование массива сущностей, где в качестве ключа выступает код плагина
				 */
				$aPluginUpdates = array();
				foreach ($mData['aData'] as $aPluginInfo) {
					$aPluginUpdates[$aPluginInfo['code']] = Engine::GetEntity('PluginAdmin_Plugins_Update', $aPluginInfo);
				}
				return $aPluginUpdates;
			}
			/*
			 * обновлений нет
			 */
			return false;
		}
		/*
		 * текст ошибки соединения с сервером
		 */
		return $mData;
	}


	/**
	 * Получение массива кодов плагинов, для которых есть обновления в каталоге из кеша (обновление каждые 5 минут)
	 *
	 * @param array $aPlugins		массив сущностей плагинов для проверки, если нужно
	 * @return string|bool|array	массив кодов и версий плагинов с обновлениям, false если нет обновлений или строка ошибки
	 */
	public function GetPluginUpdatesCached($aPlugins = array()) {
		$sCacheKey = 'admin_get_plugins_updates_' . serialize($aPlugins);
		/*
		 * есть ли в кеше
		 */
		if (($mData = $this->Cache_Get($sCacheKey)) === false) {
			$mData = $this->GetPluginUpdates($aPlugins);
			/*
			 * кеширование обновлений на 5 минут
			 */
			$this->Cache_Set($mData, $sCacheKey, array('plugin_update', 'plugin_new'), $this->aCacheLiveTime['plugin_updates_check']);
		}
		return $mData;
	}


}

?>