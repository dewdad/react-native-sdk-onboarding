import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  TextInput,
  Button,
  View
} from 'react-native';
import RNHyperTrack from 'react-native-hypertrack';


export default class HyperTrackOnboarding extends Component {
  constructor(props) {
    super(props);
    this.state = { text: 'Useless placeholder', showLogin: false };

    // Initialize HyperTrack with publishable token
    RNHyperTrack.initialize('pk_1507af78ef9dca2d250bdd6cf835e315bde4ad96');
  }

  createUser() {
    RNHyperTrack.createUser(this.state.text, (success) => {
      console.log('success', success);
    }, (error) => {
      console.log('error', error);
    })
  }

  logIn() {
    RNHyperTrack.startTracking();
  }

  logOut() {
    RNHyperTrack.stopTracking();
  }

  showLoginScreen() {
    return (
      <View style={styles.container}>
        <TextInput
          style={styles.inputBox}
          onChangeText={(text) => this.setState({text})}
          value={this.state.text}
        />

        <TextInput
          style={styles.inputBox}
          onChangeText={(text) => this.setState({text})}
          value={this.state.text}
        />

        <Button
          style={styles.buttonBox}
          onPress={this.createUser.bind(this)}
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
          onPress={this.showLogoutScreen.bind(this)}
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
