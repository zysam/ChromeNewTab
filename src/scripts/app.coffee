'use strict'

app = angular.module 'myapp',[]


CARDS_URL = 'http://study.youdao.com/card.a?method=allCardsJson&index=0
'
IMG_URL = 'http://oimagec1.ydstatic.com/image?product=dict-treasury&id='
ORICARD_KEY = 'oriCard'
MYCARD_KEY = 'uCard'
#services
app.factory 'fetch',['$http',($http)->
	getCard : (url)->
		$http({
			method : 'GET'
			url : url
		})
	getCardImg : (url)->
		$http.get(url,{ responseType:'blob'})
	]

app.controller 'main',['$scope','fetch',($scope,fetch) -> 
	#$scope.word = 'hello!'
	#$scope.cards = {}

	#get cards from youdao!
	getOriCard = (key,callback) ->
		oriCard = {}
		callback = callback or ()->
		chrome.storage.local.get key,(items)->
				if items[key] is undefined
					console.log 'no data in chrome '
					fetch.getCard(CARDS_URL).success (data)->
						console.log 'getCardJson suc :' + data[1].word
						storage = {}
						storage[ORICARD_KEY] = data

						chrome.storage.local.set storage,->
							console.log "storage oriCard"
						
						oriCard = data
						callback(oriCard)
				else
					console.info '1)oriCard:' + items[key][1].word
					oriCard = items[key]
					callback(oriCard)

	#keepMyCard
	saveMyCard = (oriCard,callback) ->
		if !oriCard[1].word
			console.log 'no card'
			return

		cards = {}
		cards[MYCARD_KEY] = []

		#copy object ,but some problem
		for n,item of oriCard
			card = {}
			card.imgId = item.imgId
			card.oriImgId = item.oriImgId
			card.en = item.examplesEn
			card.zh =  item.examplesZh
			card.word = item.word
			card.trans = item.trans
			card.pron = item.pron

			cards[MYCARD_KEY].push card
			console.info 'n)%s\card.word:%s',n,card.word

		#cards.card = card
		chrome.storage.local.set cards,->
			console.log 'storage mycard!'
			#return
		callback cards

	#get card from chrome storage key = 'mycard'
	initCard = (key,callback) ->
		myCard = {}
		callback = callback or ()->
		chrome.storage.local.get key,(items)->
			if items[key] is undefined
				console.log 'no %s in storage!',key
				#getOriCard and save
				myCard = getOriCard ORICARD_KEY,(_key)->
					saveMyCard _key,callback

				console.log 'look here,bug?!'
				#bug! how to handle
			else
				console.info '1)mycard:' + items[key][1].word
				myCard = items
				callback myCard

	initCard MYCARD_KEY,(cards)->
	#if cards.mycard
		console.log cards[MYCARD_KEY][0]
		$scope.cards = []
		$scope.$apply ->
			$scope.cards = cards[MYCARD_KEY]
		###
		for card in $scope.cards
			for k,v of card
				console.log '%s:%s',k,v
		###
		return
	]

###
		#$scope.imgId = ''
		#$scope.imgs = []

		$scope.getImg = (url) ->
			console.log 'imgId : ' + url
			fetch.getCardImg(IMG_URL + url).success (data)->
				#img.blob = window.URL.createObjectURL data
				$scope.imgs.push window.URL.createObjectURL data
				console.log 'imgs : ' + $scope.imgs.slice(-1)
				#$scope.imgs = window.URL.createObjectURL data
				#console.log 'imgs : ' + $scope.imgs
				return

		
			for n,obj of data when n is '67'
				$scope.word = obj.word
				$scope.trans = obj.trans
				fetch.getCardImg(imgUrl + obj.imgId).success (data)->
					$scope.imgsrc = window.URL.createObjectURL data
					console.log 'word : %s\ntrans : %s\n imgsrc : %s',obj.word,obj.trans,$scope.imgsrc
				return 
###