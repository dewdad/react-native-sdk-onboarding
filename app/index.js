import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  TextInput,
  Button,
  View, Alert, NativeModules
} from 'react-native';
import {RNHyperTrack as RNHyperTrackImport} from 'react-native-hypertrack';


if (NativeModules.RNHyperTrack != undefined) {
  // Import for iOS setup
  var RNHyperTrack = NativeModules.RNHyperTrack;
} else {
  // Import for Android setup
  var RNHyperTrack = RNHyperTrackImport;
}


export default class HyperTrackOnboarding extends Component {
  constructor(props) {
    super(props);
    this.state = {
      name: 'User name',
      phone: 'Phone number',
      showLogin: true
    };

    // Initialize HyperTrack with publishable token
    RNHyperTrack.initialize(YOUR_PUBLISHABLE_KEY);
  }

  createUser(successCallback, errorCallback) {
    console.log(successCallback)

    RNHyperTrack.getOrCreateUser(this.state.name, this.state.phone, this.state.phone, (success) => {
      successCallback(success);
    }, (error) => {
      errorCallback(error)
    })
  }

  onLoginSuccess(userObject) {
    console.log('Successful login: ', userObject)

    // Start tracking on HyperTrack
    RNHyperTrack.startTracking((success) => {
      this.setState({showLogin: false})
    }, (error) => {
      // Raise an alert if there's an error
      Alert.alert('Error', error);
    });
  }

  logIn() {
    this.createUser((userObject) => this.onLoginSuccess(userObject), (error) => { Alert.alert('Error', error); })
  }

  logOut() {
    // Stop tracking on HyperTrack
    RNHyperTrack.stopTracking();
    this.setState({showLogin: true});
  }

  showLoginScreen() {
    return (
      <View style={styles.container}>
        <TextInput
          style={styles.inputBox}
          onChangeText={(name) => this.setState({name})}
          value={this.state.name}
        />

        <TextInput
          style={styles.inputBox}
          onChangeText={(phone) => this.setState({phone})}
          value={this.state.phone}
        />

        <Button
          style={styles.buttonBox}
          onPress={() => this.logIn()}
          title='Log in'
          accessibilityLabel='Log in'
        />
      </View>
    );
  }

  showLogoutScreen() {
    return (
      <View style={styles.container}>
        <Button
          style={styles.buttonBox}
          onPress={this.logOut.bind(this)}
          title='Log out'
          accessibilityLabel='Log out'
        />
      </View>
    );
  }

  render() {
    let view = this.state.showLogin ? this.showLoginScreen() : this.showLogoutScreen();
    return (
      view
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },

  inputBox: {
    margin: 10,
    height: 40,
    borderColor: 'gray',
    borderWidth: 1,
    width: 300
  },

  buttonBox: {
    textAlign: 'center',
    margin: 10,
    width: 200
  }
});
