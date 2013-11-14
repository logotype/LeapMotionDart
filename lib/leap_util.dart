part of LeapMotionDart;

/**
 * LeapUtil is a collection of static utility functions.
 *
 */
class LeapUtil
{
  /** The constant pi as a single precision floating point number. */
  static const num PI = 3.1415926536;

  /**
   * The constant ratio to convert an angle measure from degrees to radians.
   * Multiply a value in degrees by this constant to convert to radians.
   */
  static const num DEG_TO_RAD = 0.0174532925;

  /**
   * The constant ratio to convert an angle measure from radians to degrees.
   * Multiply a value in radians by this constant to convert to degrees.
   */
  static const num RAD_TO_DEG = 57.295779513;

  /**
   * Pi &#42; 2.
   */
  static const num TWO_PI = Math.PI + Math.PI;

  /**
   * Pi &#42; 0.5.
   */
  static const num HALF_PI = Math.PI * 0.5;

  /**
   * Represents the smallest positive single value greater than zero.
   */
  static const num EPSILON = 0.00001;

  LeapUtil()
  {
  }

  /**
   * Convert an angle measure from radians to degrees.
   *
   * [radians]
   * [return] The value, in degrees.
   *
   */
  static num toDegrees( num radians ) => radians * 180 / Math.PI;

  /**
   * Determines if a value is equal to or less than 0.00001.
   *
   * [return] True, if equal to or less than 0.00001; false otherwise.
   */
  bool isNearZero( num value ) => value.abs() <= EPSILON;

  /**
   * Determines if all Vector3 components is equal to or less than 0.00001.
   *
   * [return] True, if equal to or less than 0.00001; false otherwise.
   */
  bool vectorIsNearZero( Vector3 inVector ) => isNearZero( inVector.x ) && isNearZero( inVector.y ) && isNearZero( inVector.z );

  /**
   * Create a new matrix with just the rotation block from the argument matrix
   */
  Matrix extractRotation( Matrix mtxTransform ) => new Matrix( x: mtxTransform.xBasis, y: mtxTransform.yBasis, z: mtxTransform.zBasis );

  /**
   * Returns a matrix representing the inverse rotation by simple transposition of the rotation block.
   */
  Matrix rotationInverse( Matrix mtxRot ) => new Matrix( x: new Vector3( mtxRot.xBasis.x, mtxRot.yBasis.x, mtxRot.zBasis.x ), y: new Vector3( mtxRot.xBasis.y, mtxRot.yBasis.y, mtxRot.zBasis.y ), z: new Vector3( mtxRot.xBasis.z, mtxRot.yBasis.z, mtxRot.zBasis.z ) );

  /**
   * Returns a matrix that is the orthonormal inverse of the argument matrix.
   * This is only valid if the input matrix is orthonormal
   * (the basis vectors are mutually perpendicular and of length 1)
   */
  Matrix rigidInverse( Matrix mtxTransform )
  {
    Matrix rigidInverse = rotationInverse( mtxTransform );
    rigidInverse.origin = rigidInverse.transformDirection( mtxTransform.origin.opposite() );
    return rigidInverse;
  }

  Vector3 componentWiseMin( Vector3 vLHS, Vector3 vRHS ) => new Vector3( Math.min( vLHS.x, vRHS.x ), Math.min( vLHS.y, vRHS.y ), Math.min( vLHS.z, vRHS.z ) );
  Vector3 componentWiseMax( Vector3 vLHS, Vector3 vRHS ) => new Vector3( Math.max( vLHS.x, vRHS.x ), Math.max( vLHS.y, vRHS.y ), Math.max( vLHS.z, vRHS.z ) );
  Vector3 componentWiseScale( Vector3 vLHS, Vector3 vRHS ) => new Vector3( vLHS.x * vRHS.x, vLHS.y * vRHS.y, vLHS.z * vRHS.z );
  Vector3 componentWiseReciprocal( Vector3 inVector ) => new Vector3( 1.0 / inVector.x, 1.0 / inVector.y, 1.0 / inVector.z );
  num minComponent( Vector3 inVector ) => Math.min( inVector.x, Math.min( inVector.y, inVector.z ) );
  num maxComponent( Vector3 inVector ) => Math.max( inVector.x, Math.max( inVector.y, inVector.z ) );

  /**
   * Compute the polar/spherical heading of a vector direction in z/x plane
   */
  num heading( Vector3 inVector ) => Math.atan2( inVector.z, inVector.x );

  /**
   * Compute the spherical elevation of a vector direction in y above the z/x plane
   */
  num elevation( Vector3 inVector ) => Math.atan2( inVector.y, Math.sqrt( inVector.z * inVector.z + inVector.x * inVector.x ) );

  /**
   * Set magnitude to 1 and bring heading to [-Pi,Pi], elevation into [-Pi/2, Pi/2]
   *
   * [vSpherical] The Vector3 to convert.
   * [return] The normalized spherical Vector3.
   *
   */
  Vector3 normalizeSpherical( Vector3 vSpherical )
  {
    num fHeading = vSpherical.y;
    num fElevation = vSpherical.z;

    while( fElevation <= -Math.PI )
      fElevation += TWO_PI;
    while( fElevation > Math.PI )
      fElevation -= TWO_PI;

    if( fElevation.abs() > HALF_PI )
    {
      fHeading += Math.PI;
      fElevation = fElevation > 0 ? ( Math.PI - fElevation ) : -( Math.PI + fElevation );
    }

    while( fHeading <= -Math.PI )
      fHeading += TWO_PI;
    while( fHeading > Math.PI )
      fHeading -= TWO_PI;

    return new Vector3( 1.0, fHeading, fElevation );
  }

  /**
   * Convert from Cartesian (rectangular) coordinates to spherical coordinates
   * (magnitude, heading, elevation).
   *
   * [vCartesian] The Vector3 to convert.
   * [return] The cartesian Vector3 converted to spherical.
   *
   */
  Vector3 cartesianToSpherical( Vector3 vCartesian ) => new Vector3( vCartesian.magnitude(), heading( vCartesian ), elevation( vCartesian ) );

  /**
   * Convert from spherical coordinates (magnitude, heading, elevation) to
   * Cartesian (rectangular) coordinates.
   *
   * [vSpherical] The Vector3 to convert.
   * [return] The spherical Vector3 converted to cartesian.
   *
   */
  Vector3 sphericalToCartesian( Vector3 vSpherical )
  {
    num fMagnitude = vSpherical.x;
    num fCosHeading = Math.cos( vSpherical.y );
    num fSinHeading = Math.sin( vSpherical.y );
    num fCosElevation = Math.cos( vSpherical.z );
    num fSinElevation = Math.sin( vSpherical.z );

    return new Vector3( fCosHeading * fCosElevation * fMagnitude, fSinElevation * fMagnitude, fSinHeading * fCosElevation * fMagnitude );
  }

  /**
   * Clamps a value between a minimum Number and maximum Number value.
   *
   * [inVal] The number to clamp.
   * [minVal] The minimum value.
   * [maxVal] The maximum value.
   * [return] The value clamped between minVal and maxVal.
   *
   */
  num clamp( num inVal, num minVal, num maxVal ) => ( inVal < minVal ) ? minVal : ( ( inVal > maxVal ) ? maxVal : inVal );

  /**
   * Linearly interpolates between two Numbers.
   *
   * [a] A number.
   * [b] A number.
   * [t] The interpolation coefficient [0-1].
   * [return] The interpolated number.
   *
   */
  num lerp( num a, num b, num coefficient ) => a + ( ( b - a ) * coefficient );

  /**
   * Linearly interpolates between two Vector3 objects.
   *
   * [a] A Vector3 object.
   * [b] A Vector3 object.
   * [t] The interpolation coefficient [0-1].
   * [return] A new interpolated Vector3 object.
   *
   */
  Vector3 lerpVector( Vector3 vec1, Vector3 vec2, num coefficient ) => vec1 + vec2 - vec1 * coefficient;
}