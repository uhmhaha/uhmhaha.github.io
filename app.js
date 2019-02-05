App = {
  web3Provider: null,
  contracts: {},
  prescriptions: [],
  presctiption_ids: [],

  init: async function() {
   
    return await App.initWeb3();
  },

  initWeb3: async function() {
    // Modern dapp browsers...
    if (window.ethereum) {
      App.web3Provider = window.ethereum;
      try {
        // Request account access
        await window.ethereum.enable();
      } catch (error) {
        // User denied account access...
        console.error("User denied account access")
      }
    }
    // Legacy dapp browsers...
    else if (window.web3) {
      App.web3Provider = window.web3.currentProvider;
    }
    // If no injected web3 instance is detected, fall back to Ganache
    else {
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }
    web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function() {
    $.getJSON('Prescription.json', function (data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract
      var Prescription = data;
      App.contracts.Prescription = TruffleContract(Prescription);

      // Set the provider for our contract
      App.contracts.Prescription.setProvider(App.web3Provider);

      // Use our contract to retrieve and mark the adopted pets
      return App.getPrescriptIds();
    });


    return App.bindEvents();
  },

  getPrescriptIds: function() {
    var prescriptionInstance;

    App.contracts.Prescription.deployed().then(function (instance) {
      prescriptionInstance = instance;

      // call contract function
      return prescriptionInstance.getPrescripitionsArrays.call();
    }).then(function (prescription_ids) {
      App.presctiption_ids = prescription_ids;
      return App.getPresciptions(prescription_ids, prescriptionInstance);
    }).then(function() {
      console.log(App.prescriptions);
      App.makeTable();
    }).catch(function (err) {
      console.log(err.message);
    });
  },

  getPresciptions: async function(ids, instance) {
    App.prescriptions = [];
    const results = ids.map(async id => {
      const prescript = await instance.getPrescripition(id);
      App.prescriptions.push(prescript);
    })
    return Promise.all(results)
  },

  createPrescribe: function(doctor, patient, drugs) {
    var prescriptionInstance;

    App.contracts.Prescription.deployed().then(function (instance) {
      prescriptionInstance = instance;

      // call contract function
      return prescriptionInstance.createPrescribe(doctor, patient, drugs);
    }).then(function() {
      return App.getPrescriptIds();
    }).catch(function (err) {
      console.log(err.message);
    });
  },

  makeTable: function() {
    // App.prescriptions
    var $tbody = $('#prescription_list tbody');
    $tbody.empty();
    for (var i = 0; i < App.prescriptions.length; i++) {
      var template = [
        '<tr>',
        '<td>' + App.presctiption_ids[i] + '</td>',
          '<td>' + App.prescriptions[i][0] + '</td>',
          '<td>' + App.prescriptions[i][1] + '</td>',
        '</tr>'
      ].join('');
      $tbody.append(template);
    }
  },

  bindEvents: function() {
    $('#save_btn').on('click', App.savePrescription);
    $('#new_btn').on('click', App.resetInput);
    $('#prescript').on('keydown', function(e) {
      if (e.keyCode == 13) {
        App.savePrescription();
      }
    })
  },

  savePrescription: function() {
    var patient = $('#patient').val();
    var doctor = $('#doctor').val();
    var prescript = $('#prescript').val();
    if (!patient || !doctor || !prescript) {
      window.alert('Please insert data');
    } else {
      App.createPrescribe(patient, doctor, prescript);
    }
  },

  resetInput: function() {
    $('#patient').val('');
    $('#doctor').val('');
    $('#prescript').val('');
  }
};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
