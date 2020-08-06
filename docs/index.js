var log;

window.onload = () => {

	if(checkIdParam()){
		cleanUpDescription();
		var id = getIdParam();
		getLog(id).then(initElm);

	}

	document.getElementById('save').addEventListener('click',function (){
		saveChart(log).then(console.log);
	});

	document.getElementById('import').addEventListener('click',function (){
		openFileDialog();
	});

	document.getElementById('file').addEventListener('change', function() {
		cleanUpDescription();
		createChart(this);
	});

};


var checkIdParam = () => {
	var urlParams = new URLSearchParams(window.location.search);
	return urlParams.has('id');
};

var getIdParam = () => {
	var urlParams = new URLSearchParams(window.location.search);
	return urlParams.get('id');
};

var openFileDialog = () => {
	document.getElementById('file').click();
};

var createChart = (e) => {
	var fr=new FileReader();
	fr.onload=function(){
		log = fr.result; // Side effect!!
		initElm(fr.result);
	}
	fr.readAsText(e.files[0]);
};

var saveChart = (log) => {
    const headers = {
      Accept: "*/*",
      "Content-Type": "text/plain",
    };
    return fetch("https://3.9.171.210/logs", {
      method: "POST",
      headers: headers,
      body: log,
    }).then((res) => res.text());
};

var cleanUpDescription = () => {
	document.getElementById('description').remove();
};

var getLog = (id) => {
    const headers = {
      Accept: "text/plain, */*",
    };
    return fetch("https://3.9.171.210/logs/" + id, {
      method: "GET",
      headers: headers,
    }).then((res) => res.text());
};

var initElm = (model) => {
	var app = Elm.Main.init({
		node: document.getElementById('myapp'),
		flags: model
	});
};
